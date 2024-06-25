import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/assets/size_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<AddTransactionScreen> {
  String transactionName = "";
  DateTime selectedDate = DateTime.now();
  List<Tag> tagList = [];
  Tag? selectedTag;
  double? amount;
  bool repeat = false; // variable für die checkbox
  final TextEditingController dateController = TextEditingController(); // für den DatePicker
  Color errorMessageColor = Colors.transparent;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    tagList = fileController.listTag;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Transaction'),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(errorMessage, style: TextStyle(color: errorMessageColor)),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter a name for the transaction',
                  ),
                  onChanged: (value) => transactionName = value,
                ),

                const SizedBox(height: 16.0),

                // Date Picker
                SizedBox(
                  width: NexusSize.inputWidth.normal,
                  height: NexusSize.inputHeight.normal,
                  child: TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Select the date',
                      icon: Icon(Icons.calendar_today)
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16.0),

                Row(
                  children: [
                    //Dropdown Tag Liste
                    SizedBox(
                      width: NexusSize.inputWidth.smal,
                      height: NexusSize.inputHeight.normal,
                      child: DropdownButtonFormField<Tag>(
                        value: selectedTag,
                        hint: const SizedBox(
                          width: 100.0,
                          child: Text(
                            'Select tags',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: NexusColor.text),
                          ),
                        ),
                        // viel Styling vielleicht kannst man das noch auslagern
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        dropdownColor: NexusColor.inputs,
                        menuMaxHeight: 150,
                        style: const TextStyle(
                          color: NexusColor.text,
                          fontSize: 16.0,
                        ),
                        items: tagList.map((Tag tag) {
                          return DropdownMenuItem<Tag>(
                            value: tag,
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                tag.tagName,
                                overflow: TextOverflow
                                    .ellipsis, // Textüberlauf behandeln
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedTag = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            width: NexusSize.inputWidth.smal,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Enter the amount',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  amount = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                          ),

                          // Checkbox for repeating transactions
                          // const SizedBox(height: 16.0),
                          // SizedBox(
                          //   width: NexusSize.inputWidth.smal,
                          //   child: TextFormField(
                          //     decoration: const InputDecoration(
                          //       labelText: 'Repeat transaction',
                          //     ),
                          //     onChanged: (value) => itemName = value,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          label: const Text('Create Transaction'),
          icon: const Icon(Icons.add),
          backgroundColor: NexusColor.accents,
          onPressed: () async {
            if (transactionName.isEmpty) {
              setState(() {
                errorMessage = "Name cannot be empty";
                errorMessageColor = Colors.red;
              });
            } else if (amount == null) {
              setState(() {
                errorMessage = "Amount cannot be empty";
                errorMessageColor = Colors.red;
              });
            } else {
              await fileController.createTransaction(transactionName, selectedDate.toIso8601String(), [1], amount);
              setState(() => errorMessageColor = Colors.transparent);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
        ),
      );
  }
}
