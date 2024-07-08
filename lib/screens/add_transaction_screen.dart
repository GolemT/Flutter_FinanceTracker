import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/assets/size_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<AddTransactionScreen> {
  String transactionName = "";
  final nexusColor = NexusColor();
  String? transactionDate;
  List<Tag>? selectedTags = [];
  double? amount;
  bool repeat = false; // variable für die checkbox
  final TextEditingController dateController = TextEditingController(); // für den DatePicker
  Color errorMessageColor = Colors.transparent;
  String errorMessage = "";

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      barrierColor: nexusColor.background,
      initialDate: DateTime.now(),
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
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    transactionDate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());
    final List<Tag> tagList = fileController.listTag;
    final items = tagList.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList();

    return Scaffold(
      backgroundColor: nexusColor.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Transaction', style: TextStyle(color: nexusColor.text)),
        backgroundColor: nexusColor.navigation,
        iconTheme: IconThemeData(color: nexusColor.text),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(errorMessage, style: TextStyle(color: errorMessageColor)),
              SizedBox(
                width: NexusSize.inputWidth.normal,
                height: NexusSize.inputHeight.normal,
                child: TextFormField(
                  maxLength: 20,
                  style: TextStyle(color: nexusColor.text),
                  decoration: InputDecoration(
                    labelText: 'Enter a name for the transaction',
                    filled: true,
                    fillColor: nexusColor.inputs,
                    labelStyle: TextStyle(color: nexusColor.text),
                    helperStyle: TextStyle(color: nexusColor.subText),
                    hintStyle: TextStyle(color: nexusColor.text),
                  ),
                  onChanged: (value) => transactionName = value,
                ),
              ),
              const SizedBox(height: 16.0),
              // Date Picker
              SizedBox(
                width: NexusSize.inputWidth.normal,
                height: NexusSize.inputHeight.normal,
                child: GestureDetector(
                  onTap: () => _selectDate(context, (pickedDate) {
                    setState(() {
                      transactionDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }),
                  child: AbsorbPointer(
                    child: TextField(
                      style: TextStyle(color: nexusColor.text),
                      controller: TextEditingController(text: transactionDate),
                      decoration: InputDecoration(
                        labelText: "Select a date",
                        filled: true,
                        fillColor: nexusColor.inputs,
                        labelStyle: TextStyle(color: nexusColor.text),
                        helperStyle: TextStyle(color: nexusColor.subText),
                        hintStyle: TextStyle(color: nexusColor.text),
                      ),
                      onChanged: (value) => {
                        // Date will be handled by DatePicker
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: MultiSelectDialogField(
                        itemsTextStyle: TextStyle(color: nexusColor.text),
                        selectedItemsTextStyle: TextStyle(color: nexusColor.text),
                        buttonIcon: Icon(Icons.arrow_drop_down, color: nexusColor.text),
                        searchable: true,
                        items: items,
                        backgroundColor: nexusColor.background,
                        title: Text("Tags", style: TextStyle(color: nexusColor.text),),
                        selectedColor: NexusColor.secondary,
                        decoration: BoxDecoration(
                          color: nexusColor.inputs,
                          border: Border.all(
                            color: nexusColor.divider,
                            width: 2,
                          ),
                        ),
                        buttonText: Text(
                          "Select Tags",
                          style: TextStyle(
                            color: nexusColor.text,
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (results) {
                          setState(() {
                            selectedTags = results.cast<Tag>();
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          alignment: Alignment.bottomCenter,
                          chipColor: nexusColor.inputs,
                          textStyle: TextStyle(color: nexusColor.text),
                          items: selectedTags?.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList() ?? [],
                          onTap: (value) {
                            setState(() {
                              selectedTags?.remove(value);
                            });
                          },
                        ),
                      ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: SizedBox(
                      height: NexusSize.inputHeight.normal,
                      child: TextFormField(
                        maxLength: 15,
                        style: TextStyle(color: nexusColor.text),
                        decoration: InputDecoration(
                          labelText: 'Enter the amount',
                          filled: true,
                          fillColor: nexusColor.inputs,
                          labelStyle: TextStyle(color: nexusColor.text),
                          helperStyle: TextStyle(color: nexusColor.subText),
                          hintStyle: TextStyle(color: nexusColor.text),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*'),
                          ),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          amount = double.tryParse(value);
                        },
                      ),
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
              errorMessageColor = NexusColor.negative;
            });
          } else if (amount == null) {
            setState(() {
              errorMessage = "Amount cannot be empty";
              errorMessageColor = NexusColor.negative;
            });
          } else {
            List<int> tagIds = selectedTags!.map((tag) => tagList.indexOf(tag)).toList();
            await fileController.createTransaction(transactionName, transactionDate.toString(), tagIds, amount!);
            setState(() => errorMessageColor = Colors.transparent);
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen())
            );
          }
        },
      ),
    );
  }
}
