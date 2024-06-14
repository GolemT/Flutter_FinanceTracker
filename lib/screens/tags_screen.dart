import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/screens/add_tag_screen.dart';
import 'package:flutter/material.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagsScreen> {

  //TODO: use real data instead of static test data
  final List<Map<String, String>> tags = [
    {'title': 'Groceries', 'description': 'dsjflkhsdjkfhslkdfhkdshgkd'},
    {'title': 'Utilities', 'description': 'djkshgflkghadkghfdjvnsdkn'},
    {
      'title': 'Entertainment',
      'description':
          'fdöybjndsökb iaugpnrehwgvrpvtiueiebrtbemhrawibghslegirwanötertwitb'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return Container(
            decoration: const BoxDecoration(
                color: NexusColor.listBackground,
                border: Border(
                    bottom: BorderSide(
                        color: NexusColor.text,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside))),
            child: ExpansionTile(
              title: Text(tag['title']!,
                  style: Theme.of(context).textTheme.bodyMedium),
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
                            hintText: tag['title'],
                            helperText: 'Name',
                            filled: true,
                          ),
                        ), // Ende TextField 1
                        const SizedBox(height: 8.0),
                        TextField(
                          decoration: InputDecoration(
                            hintText: tag['description'],
                            helperText: 'Description',
                            filled: true,
                          ),
                        ), // Ende TextField 2
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {},
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
                              onPressed: () {},
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        label: const Text('New Tag'),
        icon: const Icon(Icons.add),
        backgroundColor: NexusColor.aczents,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTagScreen()),
          );
        },
      ),
    );
  }
}
