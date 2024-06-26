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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? transactionName;
  String? transactionDate;
  List<Tag>? selectedTags;
  double? transactionAmount;

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final List<Tag> tagList = fileController.listTag;
    final items = tagList.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList();

    Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
    }
         
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
                      transaction.transactionName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      transaction.transactionAmount.toString(),
                      style: TextStyle(
                        color: transaction.transactionAmount > 0.0 ? NexusColor.positive : NexusColor.negative,
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
                                  hintText: transaction.transactionName,
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
                                onTap: () => _selectDate(context, (pickedDate) {
                                  setState(() {
                                    transactionDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                  });
                                }),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(text: transactionDate ?? transaction.transactionDate),
                                    decoration: const InputDecoration(
                                      helperText: 'Date',
                                      filled: true,
                                    ),
                                    onChanged: (value) => {
                                      // Date will be handled by DatePicker
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              MultiSelectDialogField(
                                items: items,
                                initialValue: selectedTags ?? transaction.transactionTag.map((index) => tagList[index]).toList(),
                                title: const Text("Tags"),
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
                                  items: selectedTags?.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList() ?? [],
                                  onTap: (value) {
                                    selectedTags??= transaction.transactionTag.map((index) => tagList[index]).toList();
                                    setState(() {
                                      selectedTags!.remove(value);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: transaction.transactionAmount.toString(),
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
                                      fileController.deleteTransaction(fileController.listTransaction.indexOf(transaction));
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
                                    ), // Ende ElevatedButton.styleFrom
                                    child: const Icon(
                                      Icons.delete,
                                      color: NexusColor.text,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 240.0),
                                  // Ende ElevatedButton 1
                                  ElevatedButton(
                                    onPressed: () async {
                                      selectedTags??= transaction.transactionTag.map((index) => tagList[index]).toList();
                                      List<int> selectedTagIndexes = selectedTags!.map((tag) => tagList.indexOf(tag)).toList();

                                      transactionName??= transaction.transactionName;
                                      transactionDate??= transaction.transactionDate;
                                      transactionAmount??= transaction.transactionAmount;

                                      await fileController.updateTransaction(
                                        fileController.listTransaction.indexOf(transaction),
                                        transactionName,
                                        transactionDate,
                                        selectedTagIndexes,
                                        transactionAmount
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
                                    ), // Ende ElevatedButton.styleFrom
                                    child: const Icon(
                                      Icons.check,
                                      color: NexusColor.text,
                                      size: 20,
                                    ),
                                  ),
                                  // Ende ElevatedButton 2
                                ], // Ende children Row
                              ), // Ende Row
                            ], // Ende children Column
                          ), // Ende Column
                        ),
                      ), // Ende Padding
                    ],
                  ),
                );
              },
            ),
    );
  }
}
