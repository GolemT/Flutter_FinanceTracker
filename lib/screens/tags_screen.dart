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
    String tagName = "";
    String tagDescription = "";

    return NavScreen(
      pageIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/tags');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/analytics');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      child: fileController.listTag.isEmpty
          ? Scaffold(
              body: Center(
                child: Text("No tags available", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                )
                ),
                floatingActionButton: FloatingActionButton.extended(
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
            body: ListView.builder(
              itemCount: fileController.listTag.length,
              itemBuilder: (context, index) {
                final tag = fileController.listTag[index];
                return Container(
                  decoration: const BoxDecoration(
                      color: NexusColor.background,
                      border: Border(
                          bottom: BorderSide(
                              color: NexusColor.inputs,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignInside))),
                  child: ExpansionTile(
                    iconColor: NexusColor.text,
                    collapsedIconColor: NexusColor.text,
                    title: Text(tag.tagName,
                        style: const TextStyle(color: NexusColor.text, fontSize: 18.0)),
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
                                  hintText: tag.tagName,
                                  helperText: 'Name',
                                  filled: true,
                                ),
                                onChanged: (value) => {
                                  tagName = value,
                                  },
                              ), // Ende TextField 1
                              const SizedBox(height: 8.0),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: tag.tagDescription,
                                  helperText: 'Description',
                                  filled: true,
                                ),
                                onChanged: (value) => {
                                  tagDescription = value,
                                  },
                              ), // Ende TextField 2
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
                                      if(tagName == tag.tagName && tagDescription == tag.tagDescription){
                                        return;
                                      }
                                      if (tagName.isEmpty) {
                                        tagName = tag.tagName;
                                      }
                                      if(tagDescription.isEmpty){
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
      floatingActionButton: FloatingActionButton.extended(
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
      );
  }
}
