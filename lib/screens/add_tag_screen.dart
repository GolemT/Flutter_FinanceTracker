import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTagScreen extends StatefulWidget {
  const AddTagScreen({super.key});

  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tag Name'),
                  onChanged: (value) => tagName = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tag Description'),
                  onChanged: (value) => tagDescription = value,
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => NexusColor.accents),
                  ),
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
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add Tag', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                ),
                Text(errorMessage, style: TextStyle(color: errorMessageColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
