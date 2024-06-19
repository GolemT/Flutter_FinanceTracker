import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tag', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(errorMessage, style: TextStyle(color: errorMessageColor)),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tag Name',
                    fillColor: NexusColor.inputs,
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: NexusColor.accents),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: NexusColor.divider),
                    ),
                    labelStyle: TextStyle(color: NexusColor.text),
                    helperStyle: TextStyle(color: NexusColor.subText),
                    hintStyle: TextStyle(color: NexusColor.text),
                  ),
                  onChanged: (value) => tagName = value,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tag Description',
                    fillColor: NexusColor.inputs,
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: NexusColor.accents),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: NexusColor.divider),
                    ),
                    labelStyle: TextStyle(color: NexusColor.text),
                    helperStyle: TextStyle(color: NexusColor.subText),
                    hintStyle: TextStyle(color: NexusColor.text),
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
        label: const Text('Create Tag'),
        icon: const Icon(Icons.add),
        backgroundColor: NexusColor.accents,
        onPressed: () async {
        if (tagName.isEmpty) {
          setState(() {
          errorMessage = "Name cannot be empty";
          errorMessageColor = Colors.red;
          });
        } else if (fileController.listTag.any((tag) => tag.tagName == tagName)) {
          setState(() {
          errorMessage = "Tag already exists";
          errorMessageColor = Colors.red;
          });
        } else {
          await fileController.createTag(tagName, tagDescription);
          setState(() => errorMessageColor = Colors.transparent);
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TagsScreen()),
          );
        }
        },
      ),  
    );
  }
}
