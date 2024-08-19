import 'package:finance_tracker/components/Currency_formatter.dart';
import 'package:finance_tracker/components/validators.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:finance_tracker/components/localisations.dart';

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
  late TextEditingController transactionNameController;
  late TextEditingController transactionDateController;
  late TextEditingController transactionAmountController;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    transactionName = ValueNotifier(widget.transaction.transactionName);
    transactionDate = ValueNotifier(widget.transaction.transactionDate);
    selectedTags = ValueNotifier(widget.transaction.transactionTag
        .map((index) => widget.tagList[index])
        .toList());
    transactionAmount = ValueNotifier(widget.transaction.transactionAmount);

    transactionNameController =
        TextEditingController(text: widget.transaction.transactionName);
    transactionDateController =
        TextEditingController(text: widget.transaction.transactionDate);
    transactionAmountController = TextEditingController(
        text: widget.transaction.transactionAmount.toString());
  }

  @override
  void dispose() {
    transactionName.dispose();
    transactionDate.dispose();
    selectedTags.dispose();
    transactionAmount.dispose();
    transactionNameController.dispose();
    transactionDateController.dispose();
    transactionAmountController.dispose();
    super.dispose();
  }

  void _resetValues() {
    transactionName.value = widget.transaction.transactionName;
    transactionDate.value = widget.transaction.transactionDate;
    selectedTags.value = widget.transaction.transactionTag
        .map((index) => widget.tagList[index])
        .toList();
    transactionAmount.value = widget.transaction.transactionAmount;

    transactionNameController.text = widget.transaction.transactionName;
    transactionDateController.text = widget.transaction.transactionDate;
    transactionAmountController.text =
        widget.transaction.transactionAmount.toString();
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
      transactionDateController.text = transactionDate.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
            color: widget.transaction.transactionAmount > 0.0
                ? NexusColor.positive
                : NexusColor.negative,
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
                  TextField(
                    controller: transactionNameController,
                    maxLength: 20,
                    style: TextStyle(color: nexusColor.text),
                    decoration: InputDecoration(
                      hintText: transactionNameController.text,
                      helperText: localizations.translate('name'),
                      filled: true,
                      fillColor: nexusColor.inputs,
                      errorText: Validators.validateName(
                          transactionName.value, context),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        transactionName.value = newValue;
                        Validators.validateName(transactionName.value, context);
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: transactionDateController,
                        style: TextStyle(color: nexusColor.text),
                        decoration: InputDecoration(
                          helperText: 'Date',
                          filled: true,
                          fillColor: nexusColor.inputs,
                        ),
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
                        selectedItemsTextStyle:
                            TextStyle(color: nexusColor.text),
                        items: widget.items,
                        initialValue: value,
                        title: Text(localizations.translate('tags'),
                            style: TextStyle(color: nexusColor.text)),
                        selectedColor: Colors.blue,
                        decoration: BoxDecoration(
                          color: nexusColor.inputs,
                          border: Border.all(
                            color: nexusColor.divider,
                            width: 2,
                          ),
                        ),
                        buttonIcon:
                            Icon(Icons.arrow_drop_down, color: nexusColor.text),
                        buttonText: Text(
                          localizations.translate('selectTagsButton'),
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
                          items: value
                              .map((tag) =>
                                  MultiSelectItem<Tag>(tag, tag.tagName))
                              .toList(),
                          onTap: (tag) {
                            value.remove(tag);
                            selectedTags.value = List<Tag>.from(value);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: transactionAmountController,
                    maxLength: 13,
                    style: TextStyle(color: nexusColor.text),
                    decoration: InputDecoration(
                      hintText: transactionAmountController.text,
                      helperText: localizations.translate('amount'),
                      filled: true,
                      fillColor: nexusColor.inputs,
                      errorText: Validators.validateAmount(
                          transactionAmount.value.toString(), context),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                      CurrencyInputFormatter(),
                    ],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (newValue) {
                      setState(() {
                        transactionAmount.value =
                            double.tryParse(newValue) ?? 0.0;
                        Validators.validateAmount(
                            transactionAmount.value.toString(), context);
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          widget.fileController.deleteTransaction(widget
                              .fileController.listTransaction
                              .indexOf(widget.transaction));
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
                          if (Validators.validateName(
                                      transactionName.value, context) ==
                                  null &&
                              Validators.validateAmount(
                                      transactionAmount.value.toString(),
                                      context) ==
                                  null) {
                            List<int> selectedTagIndexes = selectedTags.value
                                .map((tag) => widget.tagList.indexOf(tag))
                                .toList();

                            await widget.fileController.updateTransaction(
                              widget.fileController.listTransaction
                                  .indexOf(widget.transaction),
                              transactionName.value,
                              transactionDate.value,
                              selectedTagIndexes,
                              transactionAmount.value,
                            );
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/home',
                              );
                            }
                          }
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
