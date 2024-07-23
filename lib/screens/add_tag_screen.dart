import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/components/localisations.dart';

class AddTagScreen extends StatefulWidget {
  const AddTagScreen({super.key});

  @override
  AddTagScreenState createState() => AddTagScreenState();
}

class AddTagScreenState extends State<AddTagScreen> {
  String tagName = "";
  String tagDescription = "";
  Color errorMessageColor = Colors.transparent;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final fileController = context.read<FileController>();
    final nexusColor = NexusColor();

    return Scaffold(
      backgroundColor: nexusColor.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('addTag'), style: TextStyle(color: nexusColor.text)),
        backgroundColor: nexusColor.navigation,
        iconTheme: IconThemeData(color: nexusColor.text),
      ),
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(errorMessage, style: TextStyle(color: errorMessageColor)),
                TextFormField(
                  controller: TextEditingController(),
                  maxLength: 20,
                  style: TextStyle(color: nexusColor.text),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate('tagName'),
                    fillColor: nexusColor.inputs,
                    filled: true,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: NexusColor.accents),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: nexusColor.divider),
                    ),
                    labelStyle: TextStyle(color: nexusColor.text),
                    helperStyle: TextStyle(color: nexusColor.subText),
                    hintStyle: TextStyle(color: nexusColor.text),
                  ),
                  onChanged: (value) => tagName = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController(),
                  maxLength: 150,
                  style: TextStyle(color: nexusColor.text),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).translate('tagDescr'),
                    fillColor: nexusColor.inputs,
                    filled: true,
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: NexusColor.accents),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: nexusColor.divider),
                    ),
                    labelStyle: TextStyle(color: nexusColor.text),
                    helperStyle: TextStyle(color: nexusColor.subText),
                    hintStyle: TextStyle(color: nexusColor.text),
                  ),
                  onChanged: (value) => tagDescription = value,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        label:  Text(AppLocalizations.of(context).translate('tagCreate')),
        icon: const Icon(Icons.add),
        backgroundColor: NexusColor.accents,
        onPressed: () async {
        if (tagName.isEmpty) {
          setState(() {
          errorMessage = AppLocalizations.of(context).translate('noEmptyNameError');
          errorMessageColor = NexusColor.negative;
          });
        } else if (fileController.listTag.any((tag) => tag.tagName == tagName)) {
          setState(() {
          errorMessage = AppLocalizations.of(context).translate('duplicateTagError');
          errorMessageColor = NexusColor.negative;
          });
        } else {
          await fileController.createTag(tagName, tagDescription);
          setState(() => errorMessageColor = Colors.transparent);
          if(context.mounted){
            await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TagsScreen()),
          );
          }
        }
        },
      ),  
    );
  }
}
