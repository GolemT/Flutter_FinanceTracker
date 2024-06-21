import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/assets/size_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<AddTransactionScreen> {

  void initState() {
    super.initState();
    // Loading the tags initially when the screen is created
    Future.microtask(() => context.read<FileController>().readTag());
  }

  String itemName = "";
  DateTime? _selectedDate;
  String? _selectedTag;
  final List<String> _tags = [];
  double expanses = 0.00;
  bool repeat = false;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              // Erstes Input Feld
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                ),
                onChanged: (value) => itemName = value,
              ),

              const SizedBox(height: 16.0),

              // Date Picker
              SizedBox(
                width: NexusSize.inputWidth.normal,
                height: NexusSize.inputHeight.normal,
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Pick the date',
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
                        _selectedDate = pickedDate;
                        _dateController.text =
                            "${pickedDate.toLocal()}".split(' ')[0];
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
                    child: DropdownButtonFormField<String>(
                      value: _selectedTag,
                      hint: const SizedBox(
                        width: 100.0,
                        child: Text(
                          'Tag wählen',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: NexusColor.text),
                        ),
                      ),
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
                      items: _tags.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                            width: 100,
                            child: Text(
                              value,
                              overflow: TextOverflow
                                  .ellipsis, // Textüberlauf behandeln
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTag = newValue;
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
                              labelText: 'Enter your expanses',
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                expanses = double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: NexusSize.inputWidth.smal,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Repeat transaction',
                            ),
                            onChanged: (value) => itemName = value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
