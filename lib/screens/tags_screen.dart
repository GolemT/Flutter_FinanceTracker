import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/add_tag_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/components/nav_screen.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  TagScreenState createState() => TagScreenState();
}

class TagScreenState extends State<TagsScreen> {
  @override
  void initState() {
    super.initState();
    // Loading the tags initially when the screen is created
    Future.microtask(() => context.read<FileController>().readTag());
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final nexusColor = NexusColor();
    String tagName = "";
    String tagDescription = "";

    return NavScreen(
      pageIndex: 1,
      child: fileController.listTag.isEmpty
          ? Scaffold(
              backgroundColor: nexusColor.background,
              body: Center(
                child: Text(
                  "No tags available",
                  style: TextStyle(color: nexusColor.text, fontSize: 20.0),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                heroTag: 'newTagButton', // Add a unique heroTag here
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                label: const Text('New Tag'),
                backgroundColor: NexusColor.accents,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTagScreen()),
                  );
                  fileController.readTag(); // Update tags after returning from AddTagScreen
                },
              ),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: nexusColor.background,
              body: ListView.builder(
                itemCount: fileController.listTag.length,
                itemBuilder: (context, index) {
                  final tag = fileController.listTag[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: nexusColor.background,
                      border: Border(
                        bottom: BorderSide(
                          color: nexusColor.inputs,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                    ),
                    child: ExpansionTile(
                      iconColor: nexusColor.text,
                      collapsedIconColor: nexusColor.text,
                      title: Text(
                        tag.tagName,
                        style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                      ),
                      children: <Widget>[
                        Container(
                          color: nexusColor.background,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextField(
                                  controller: TextEditingController(text: tag.tagName),
                                  maxLength: 20,
                                  style: TextStyle(color: nexusColor.text),
                                  decoration: InputDecoration(
                                    hintText: tag.tagName,
                                    helperText: 'Name',
                                    filled: true,
                                    fillColor: nexusColor.inputs,
                                  ),
                                  onChanged: (value) => {
                                    tagName = value,
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                TextField(
                                  controller: TextEditingController(text: tag.tagDescription),
                                  maxLength: 150,
                                  style: TextStyle(color: nexusColor.text),
                                  decoration: InputDecoration(
                                    helperText: 'Description',
                                    filled: true,
                                    fillColor: nexusColor.inputs,
                                  ),
                                  onChanged: (value) => {
                                    tagDescription = value,
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        fileController.deleteTag(fileController.listTag.indexOf(tag));
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/tags',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(8.0),
                                        minimumSize: const Size(37, 37),
                                        maximumSize: const Size(37, 37),
                                        backgroundColor: NexusColor.negative,
                                      ),
                                      child: Icon(
                                        Icons.delete,
                                        color: nexusColor.text,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 240.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (tagName == tag.tagName && tagDescription == tag.tagDescription) {
                                          return;
                                        }
                                        if (tagName.isEmpty) {
                                          tagName = tag.tagName;
                                        }
                                        if (tagDescription.isEmpty) {
                                          tagDescription = tag.tagDescription;
                                        }
                                        fileController.updateTag(fileController.listTag.indexOf(tag), tagName, tagDescription);
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/tags',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(8.0),
                                        minimumSize: const Size(37, 37),
                                        maximumSize: const Size(37, 37),
                                        backgroundColor: NexusColor.positive,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: nexusColor.text,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                heroTag: 'newTagButton',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                label: const Text('New Tag'),
                backgroundColor: NexusColor.accents,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTagScreen()),
                  );
                  fileController.readTag();
                },
              ),
            ),
    );
  }
}
