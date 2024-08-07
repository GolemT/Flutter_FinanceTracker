import 'package:finance_tracker/components/validators.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/localisations.dart';

class TagItem extends StatefulWidget {
  final Tag tag;
  final FileController fileController;

  const TagItem({
    super.key,
    required this.tag,
    required this.fileController,
  });

  @override
  TagItemState createState() => TagItemState();
}

class TagItemState extends State<TagItem> {
  final NexusColor nexusColor = NexusColor();
  late ValueNotifier<String> tagName;
  late ValueNotifier<String> tagDescription;
  late TextEditingController tagNameController;
  late TextEditingController tagDescriptionController;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    tagName = ValueNotifier(widget.tag.tagName);
    tagDescription = ValueNotifier(widget.tag.tagDescription);

    tagNameController = TextEditingController(text: widget.tag.tagName);
    tagDescriptionController = TextEditingController(text: widget.tag.tagDescription);
  }

  @override
  void dispose() {
    tagName.dispose();
    tagDescription.dispose();
    tagNameController.dispose();
    tagDescriptionController.dispose();
    super.dispose();
  }

  void _resetValues() {
    tagName.value = widget.tag.tagName;
    tagDescription.value = widget.tag.tagDescription;

    tagNameController.text = widget.tag.tagName;
    tagDescriptionController.text = widget.tag.tagDescription;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
        title: Text(
          widget.tag.tagName,
          style: TextStyle(color: nexusColor.text, fontSize: 20),
        ),
      onExpansionChanged: (bool expanded) {
          setState(() {
            isExpanded = expanded;
            if (!isExpanded) {
              _resetValues();
            }
          });
        },
        children: <Widget>[
          Container(
            color: nexusColor.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: tagNameController,
                    maxLength: 20,
                    style: TextStyle(color: nexusColor.text),
                    decoration: InputDecoration(
                      hintText: tagNameController.text,
                      helperText: localizations.translate('name'),
                      filled: true,
                      fillColor: nexusColor.inputs,
                      errorText: Validators.validateNameDouble(tagName.value, context, widget.fileController, name: widget.tag.tagName),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        tagName.value = newValue;
                        Validators.validateNameDouble(tagName.value, context, widget.fileController, name: widget.tag.tagName);
                      });
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: tagDescriptionController,
                    maxLength: 150,
                    style: TextStyle(color: nexusColor.text),
                    decoration: InputDecoration(
                      hintText: tagDescriptionController.text,
                      helperText: localizations.translate('description'),
                      filled: true,
                      fillColor: nexusColor.inputs,
                    ),
                    onChanged: (newValue) {
                      tagDescription.value = newValue;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          widget.fileController.deleteTag(widget.fileController.listTag.indexOf(widget.tag));
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
                          if(Validators.validateNameDouble(tagName.value, context, widget.fileController) == null) {
                            await widget.fileController.updateTag(
                              widget.fileController.listTag.indexOf(widget.tag),
                              tagName.value,
                              tagDescription.value,
                            );
                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/tags',
                              );
                            }
                          }
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
  }
}
