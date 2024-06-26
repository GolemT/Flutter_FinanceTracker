import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final List<Tag> tagList;
  final List<MultiSelectItem<Tag>> items;
  final FileController fileController;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.tagList,
    required this.items,
    required this.fileController,
  });

  @override
  TransactionItemState createState() => TransactionItemState();
}

class TransactionItemState extends State<TransactionItem> {
  late ValueNotifier<String> transactionName;
  late ValueNotifier<String> transactionDate;
  late ValueNotifier<List<Tag>> selectedTags;
  late ValueNotifier<double> transactionAmount;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    transactionName = ValueNotifier(widget.transaction.transactionName);
    transactionDate = ValueNotifier(widget.transaction.transactionDate);
    selectedTags = ValueNotifier(widget.transaction.transactionTag.map((index) => widget.tagList[index]).toList());
    transactionAmount = ValueNotifier(widget.transaction.transactionAmount);
  }

  void _resetValues() {
    transactionName.value = widget.transaction.transactionName;
    transactionDate.value = widget.transaction.transactionDate;
    selectedTags.value = widget.transaction.transactionTag.map((index) => widget.tagList[index]).toList();
    transactionAmount.value = widget.transaction.transactionAmount;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(transactionDate.value),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: NexusColor.text,
            colorScheme: const ColorScheme.dark(primary: NexusColor.text, onPrimary: NexusColor.background),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      transactionDate.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NexusColor.listBackground,
        border: Border(
          bottom: BorderSide(
            color: NexusColor.text,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          widget.transaction.transactionName,
          style: const TextStyle(color: NexusColor.text, fontSize: 20),
        ),
        trailing: Text(
          widget.transaction.transactionAmount.toString(),
          style: TextStyle(
            color: widget.transaction.transactionAmount > 0.0 ? NexusColor.positive : NexusColor.negative,
            fontSize: 18,
          ),
        ),
        onExpansionChanged: (bool expanded) {
          setState(() {
            isExpanded = expanded;
            if (!isExpanded) {
              _resetValues();
            }
          });
        },
        children: <Widget>[
          Container(
            color: NexusColor.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ValueListenableBuilder<String>(
                    valueListenable: transactionName,
                    builder: (context, value, child) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: value,
                          helperText: 'Name',
                          filled: true,
                        ),
                        onChanged: (newValue) {
                          transactionName.value = newValue;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: ValueListenableBuilder<String>(
                        valueListenable: transactionDate,
                        builder: (context, value, child) {
                          return TextField(
                            controller: TextEditingController(text: value),
                            decoration: const InputDecoration(
                              helperText: 'Date',
                              filled: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ValueListenableBuilder<List<Tag>>(
                    valueListenable: selectedTags,
                    builder: (context, value, child) {
                      return MultiSelectDialogField(
                        backgroundColor: NexusColor.background,
                        searchable: true,
                        itemsTextStyle: const TextStyle(color: NexusColor.text),
                        selectedItemsTextStyle: const TextStyle(color: NexusColor.text),
                        items: widget.items,
                        initialValue: value,
                        title: const Text("Tags", style: TextStyle(color: NexusColor.text)),
                        selectedColor: Colors.blue,
                        decoration: BoxDecoration(
                          color: NexusColor.inputs,
                          border: Border.all(
                            color: NexusColor.divider,
                            width: 2,
                          ),
                        ),
                        buttonIcon: const Icon(Icons.arrow_drop_down, color: NexusColor.text),
                        buttonText: const Text(
                          "Select Tags",
                          style: TextStyle(
                            color: NexusColor.text,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          selectedTags.value = results.cast<Tag>();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          chipColor: NexusColor.inputs,
                          textStyle: const TextStyle(color: NexusColor.text),
                          items: value.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList(),
                          onTap: (tag) {
                            value.remove(tag);
                            selectedTags.value = List<Tag>.from(value);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ValueListenableBuilder<double>(
                    valueListenable: transactionAmount,
                    builder: (context, value, child) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: value.toString(),
                          helperText: 'Amount',
                          filled: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*'),
                          ),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (newValue) {
                          transactionAmount.value = double.tryParse(newValue) ?? 0.0;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          widget.fileController.deleteTransaction(widget.fileController.listTransaction.indexOf(widget.transaction));
                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: const Size(37, 37),
                          maximumSize: const Size(37, 37),
                          backgroundColor: NexusColor.negative,
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: NexusColor.text,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 240.0),
                      ElevatedButton(
                        onPressed: () async {
                          List<int> selectedTagIndexes = selectedTags.value.map((tag) => widget.tagList.indexOf(tag)).toList();

                          await widget.fileController.updateTransaction(
                            widget.fileController.listTransaction.indexOf(widget.transaction),
                            transactionName.value,
                            transactionDate.value,
                            selectedTagIndexes,
                            transactionAmount.value,
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(8.0),
                          minimumSize: const Size(37, 37),
                          maximumSize: const Size(37, 37),
                          backgroundColor: NexusColor.positive,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: NexusColor.text,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
