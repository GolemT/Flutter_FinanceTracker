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
  final NexusColor nexusColor = NexusColor();
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
          data: ThemeData(
            primaryColor: nexusColor.text,
            colorScheme: ColorScheme.dark(
              primary: nexusColor.text,
              onPrimary: nexusColor.background,
              surface: nexusColor.background,
              onSurface: nexusColor.text,
            ),
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
      decoration: BoxDecoration(
        color: nexusColor.background,
        border: Border(
          bottom: BorderSide(
            color: nexusColor.inputs,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          widget.transaction.transactionName,
          style: TextStyle(color: nexusColor.text, fontSize: 20),
        ),
        subtitle: Text(
          widget.transaction.transactionDate,
          style: TextStyle(color: nexusColor.subText, fontSize: 16),
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
            color: nexusColor.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ValueListenableBuilder<String>(
                    valueListenable: transactionName,
                    builder: (context, value, child) {
                      return TextField(
                        controller: TextEditingController(text: value),
                        maxLength: 20,
                        style: TextStyle(color: nexusColor.text),
                        decoration: InputDecoration(
                          hintText: value,
                          helperText: 'Name',
                          filled: true,
                          fillColor: nexusColor.inputs,
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
                            style: TextStyle(color: nexusColor.text),
                            decoration: InputDecoration(
                              helperText: 'Date',
                              filled: true,
                              fillColor: nexusColor.inputs,
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
                        backgroundColor: nexusColor.background,
                        searchable: true,
                        itemsTextStyle: TextStyle(color: nexusColor.text),
                        selectedItemsTextStyle: TextStyle(color: nexusColor.text),
                        items: widget.items,
                        initialValue: value,
                        title: Text("Tags", style: TextStyle(color: nexusColor.text)),
                        selectedColor: Colors.blue,
                        decoration: BoxDecoration(
                          color: nexusColor.inputs,
                          border: Border.all(
                            color: nexusColor.divider,
                            width: 2,
                          ),
                        ),
                        buttonIcon: Icon(Icons.arrow_drop_down, color: nexusColor.text),
                        buttonText: Text(
                          "Select Tags",
                          style: TextStyle(
                            color: nexusColor.text,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          selectedTags.value = results.cast<Tag>();
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          chipColor: nexusColor.inputs,
                          textStyle: TextStyle(color: nexusColor.text),
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
                        controller: TextEditingController(text: value.toString()),
                        maxLength: 15,
                        style: TextStyle(color: nexusColor.text),
                        decoration: InputDecoration(
                          hintText: value.toString(),
                          helperText: 'Amount',
                          filled: true,
                          fillColor: nexusColor.inputs,
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
                        child: Icon(
                          Icons.delete,
                          color: nexusColor.text,
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
                        child: Icon(
                          Icons.check,
                          color: nexusColor.text,
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
