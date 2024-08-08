import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/tag_item.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/add_tag_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:finance_tracker/components/localisations.dart';

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

    return NavScreen(
      pageIndex: 1,
      child: SafeArea(
        child: fileController.listTag.isEmpty
          ? Scaffold(
              backgroundColor: nexusColor.background,
              body: Center(
                child: Text(
                  AppLocalizations.of(context).translate('noTags'),
                  style: TextStyle(color: nexusColor.text, fontSize: 20.0),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                heroTag: 'newTagButton', // Add a unique heroTag here
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                label: Text(AppLocalizations.of(context).translate('newTag')),
                icon: const Icon(Icons.add),
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
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: fileController.listTag.length,
                        itemBuilder: (context, index) {
                          List<Tag> list = List.from(fileController.listTag);
                          final tag = list[index];
                          return TagItem(
                            tag: tag,
                            fileController: fileController,
                          );
                        },
                      ),
              floatingActionButton: FloatingActionButton.extended(
                heroTag: 'newTagButton',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                label: Text(AppLocalizations.of(context).translate('newTag')),
                icon: const Icon(Icons.add),
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
      )
    );
  }
}
