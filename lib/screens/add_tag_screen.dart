import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/validators.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/components/localisations.dart';

class AddTagScreen extends StatefulWidget {

  const AddTagScreen({
    super.key,
  });

  @override
  AddTagScreenState createState() => AddTagScreenState();
}

class AddTagScreenState extends State<AddTagScreen> {
  String tagName = "";
  String tagDescription = "";
  Color errorMessageColor = Colors.transparent;
  String errorMessage = "";

  late TextEditingController tagNameController;
  late TextEditingController tagDescriptionController;

  @override
  void initState() {
    super.initState();

    tagNameController = TextEditingController(text: '');
    tagDescriptionController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.read<FileController>();
    final nexusColor = NexusColor();
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: nexusColor.background,
      appBar: AppBar(
        title: Text(localizations.translate('addTag'),
            style: TextStyle(color: nexusColor.text)),
        backgroundColor: nexusColor.navigation,
        iconTheme: IconThemeData(color: nexusColor.text),
      ),
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: tagNameController,
                  maxLength: 20,
                  style: TextStyle(color: nexusColor.text),
                  decoration: InputDecoration(
                    labelText:
                        localizations.translate('tagName'),
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
                    errorText: Validators.validateNameDouble(tagName, context, fileController),
                  ),
                  onChanged: (value) {
                    setState(() {
                    tagName = value;
                    Validators.validateNameDouble(tagName, context, fileController);
                    });
                  }
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: tagDescriptionController,
                  maxLength: 150,
                  style: TextStyle(color: nexusColor.text),
                  decoration: InputDecoration(
                    labelText:
                        localizations.translate('tagDescr'),
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        label: Text(AppLocalizations.of(context).translate('tagCreate')),
        icon: const Icon(Icons.add),
        backgroundColor: NexusColor.accents,
        onPressed: () async {
          if (Validators.validateNameDouble(tagName, context, fileController) == null) {
            await fileController.createTag(tagName, tagDescription);
            if (context.mounted) {
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
