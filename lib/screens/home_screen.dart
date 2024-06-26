import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/services.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final List<Tag> tagList = fileController.listTag;
    final items = tagList.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList();

    return NavScreen(
      pageIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/tags');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/addTransaction');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/analytics');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      child: fileController.listTransaction.isEmpty
          ? Center(
              child: Text(
                "No transactions available",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            )
          : ListView.builder(
              itemCount: fileController.listTransaction.length,
              itemBuilder: (context, index) {
                final transaction = fileController.listTransaction[index];
                return TransactionItem(
                  transaction: transaction,
                  tagList: tagList,
                  items: items,
                  fileController: fileController,
                );
              },
            ),
    );
  }
}

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
  late String transactionName;
  late String transactionDate;
  late List<Tag> selectedTags;
  late double transactionAmount;

  @override
  void initState() {
    super.initState();
    transactionName = widget.transaction.transactionName;
    transactionDate = widget.transaction.transactionDate;
    selectedTags = widget.transaction.transactionTag.map((index) => widget.tagList[index]).toList();
    transactionAmount = widget.transaction.transactionAmount;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(transactionDate),
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
      setState(() {
        transactionDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
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
          transactionName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Text(
          transactionAmount.toString(),
          style: TextStyle(
            color: transactionAmount > 0.0 ? NexusColor.positive : NexusColor.negative,
          ),
        ),
        children: <Widget>[
          Container(
            color: NexusColor.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: transactionName,
                      helperText: 'Name',
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        transactionName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: TextEditingController(text: transactionDate),
                        decoration: const InputDecoration(
                          helperText: 'Date',
                          filled: true,
                        ),
                        onChanged: (value) {
                          // Date will be handled by DatePicker
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  MultiSelectDialogField(
                    backgroundColor: NexusColor.background,
                    searchable: true,
                    itemsTextStyle: const TextStyle(color: NexusColor.text),
                    selectedItemsTextStyle: const TextStyle(color: NexusColor.text),
                    items: widget.items,
                    initialValue: selectedTags,
                    title: const Text("Tags", style: TextStyle(color: NexusColor.text)),
                    selectedColor: Colors.blue,
                    decoration: BoxDecoration(
                      color: NexusColor.inputs,
                      border: Border.all(
                        color: NexusColor.divider,
                        width: 2,
                      ),
                    ),
                    buttonText: const Text(
                      "Select Tags",
                      style: TextStyle(
                        color: NexusColor.text,
                        fontSize: 16,
                      ),
                    ),
                    onConfirm: (results) {
                      setState(() {
                        selectedTags = results.cast<Tag>();
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      chipColor: NexusColor.inputs,
                      textStyle: const TextStyle(color: NexusColor.text),
                      items: selectedTags.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList(),
                      onTap: (value) {
                        setState(() {
                          selectedTags.remove(value);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: transactionAmount.toString(),
                      helperText: 'Amount',
                      filled: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        transactionAmount = double.tryParse(value) ?? 0.0;
                      });
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
                          List<int> selectedTagIndexes = selectedTags.map((tag) => widget.tagList.indexOf(tag)).toList();

                          await widget.fileController.updateTransaction(
                            widget.fileController.listTransaction.indexOf(widget.transaction),
                            transactionName,
                            transactionDate,
                            selectedTagIndexes,
                            transactionAmount,
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
