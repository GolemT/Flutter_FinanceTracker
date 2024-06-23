import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/assets/size_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//TODO Sorry das ich nicht mehr geschafft habe tut mir echt leid das an euch so viel abfällt...
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<AddTransactionScreen> {
  String itemName = ""; // Input Feld für den Namen der Ausgbe
  DateTime? _selectedDate; // Variable für das Datum der Ausgabe
  List<String> testList = ['Test1', 'Test2']; // Testdaten für das Select Feld
  String? _selectedTag; // speichert den ausgewählten Tag
  double expanses = 0.00; // speichert die Ausgaben
  bool repeat =
      false; // variable für die checkbox (noch nicht implementiert sorry)
  final TextEditingController _dateController =
      TextEditingController(); // für den DatePicker

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
              // Input Feld für Name
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
                    // Kalender zur Datumsauswahl
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
                      // viel Styling vielleicht kannst du das noch auslagern wäre zuckersüß mein Mäuschen
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
                      // TODO: Backend einbinden
                      items: testList.map((String value) {
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
                      // speichert die ausgewählte Variable
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTag = newValue;
                        });
                      },
                    ),
                  ),
                  // Input Feld für die Ausgaben
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
                            // Speichert die horrenden Summen
                            onChanged: (value) {
                              setState(() {
                                expanses = double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                        ),

                        // Repeat Checkbox
                        // TODO: Checkbox hinzufügen und Textbox unbearbeitbar machen
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
