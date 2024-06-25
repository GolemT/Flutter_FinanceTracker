import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/services.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:intl/intl.dart';

// TODO: Instant Refresh of screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    String? transactionName;
    String? transactionDate;
    List<Tag>? selectedTags;
    double? transactionAmount;

    void onTagsChanged(List<Tag> tags) {
      selectedTags = tags;
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
          ? Center(child: Text("No transactions available", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),))
          : Scaffold(
            body: ListView.builder(
              itemCount: fileController.listTransaction.length,
              itemBuilder: (context, index) {
                final transaction = fileController.listTransaction[index];
                transactionDate ??= DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.transactionDate));
                selectedTags ??= fileController.listTag.where((tag) => transaction.transactionTag.contains(fileController.listTag.indexOf(tag))).toList();
                return Container(
                  decoration: const BoxDecoration(
                      color: NexusColor.listBackground,
                      border: Border(
                          bottom: BorderSide(
                              color: NexusColor.text,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignInside))),
                  child: ExpansionTile(
                    title: Text(transaction.transactionName,
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Text(transaction.transactionAmount.toString(), style: TextStyle(color: transaction.transactionAmount > 0.0 ? NexusColor.positive : NexusColor.negative)),
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
                                onChanged: (value) => {
                                  transactionName = value,
                                },
                              ),
                              const SizedBox(height: 8.0),
                              GestureDetector(
                                onTap: () => _selectDate(context, (pickedDate) {
                                  transactionDate = pickedDate.toString();
                                  // Update the text field to show the selected date
                                }),
                                child: AbsorbPointer(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: transactionDate,
                                      helperText: 'Date',
                                      filled: true,
                                    ),
                                    onChanged: (value) => {
                                      // Date will be handled by DatePicker
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              DropdownButtonFormField<Tag>(
                                decoration: const InputDecoration(
                                  hintText: 'Select tags',
                                  helperText: 'Tags',
                                  filled: true,
                                  fillColor: NexusColor.inputs,
                                ),
                                // TODO: Instant refresh when selecting a tag/deleting a tag
                                value: selectedTags != null && selectedTags!.isNotEmpty ? selectedTags!.first : null,
                                isExpanded: true,
                                items: fileController.listTag.map((Tag tag) {
                                  return DropdownMenuItem<Tag>(
                                    value: tag,
                                    child: Text(tag.tagName),
                                  );
                                }).toList(),
                                onChanged: (Tag? newValue) {
                                  if (newValue != null) {
                                    selectedTags ??= [];
                                    if (!selectedTags!.contains(newValue)) {
                                      selectedTags!.add(newValue);
                                      onTagsChanged(selectedTags!);
                                    }
                                  }
                                },
                                dropdownColor: NexusColor.inputs, // Ensures the background color of the dropdown
                              ),
                              Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: selectedTags != null
                                    ? selectedTags!.map((Tag tag) {
                                        return Chip(
                                          label: Text(tag.tagName),
                                          onDeleted: () {
                                            selectedTags!.remove(tag);
                                            onTagsChanged(selectedTags!);
                                          },
                                        );
                                      }).toList()
                                    : transaction.transactionTagName.map((tagName) {
                                        return Chip(
                                          label: Text(tagName),
                                        );
                                      }).toList(),
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
                                onChanged: (value) => {
                                  transactionAmount = double.tryParse(value),
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
                                      transactionName ??= transaction.transactionName;
                                      transactionDate ??= DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.transactionDate));
                                      selectedTags ??= fileController.listTag.where((tag) => transaction.transactionTag.contains(fileController.listTag.indexOf(tag))).toList();
                                      transactionAmount ??= transaction.transactionAmount;

                                      if(transactionName == transaction.transactionName 
                                      && transactionDate.toString() == transaction.transactionDate 
                                      && selectedTags!.map((e) => fileController.listTag.indexOf(e)).toList().toString() == transaction.transactionTag.toString()
                                      && transactionAmount == transaction.transactionAmount){
                                        return;
                                      }

                                      List<int> selectedTagIndexes = selectedTags!.map((tag) => fileController.listTag.indexOf(tag)).toList();

                                      fileController.updateTransaction(
                                        fileController.listTransaction.indexOf(transaction), 
                                        transactionName, 
                                        transactionDate.toString(), 
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
        ),
    );
  }
}
