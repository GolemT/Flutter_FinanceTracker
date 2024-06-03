import 'package:finance_tracker/screens/add_tag_screen.dart';
import 'package:flutter/material.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagsScreen> {
  final List tags = ['Groceries', 'Utilities', 'Entertainment'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(
                color: Color(0xFF000000),
                border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF272727),
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside))),
            child: ListTile(
              title: Text(tags[index],
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        label: const Text('New Tag'),
        icon: const Icon(Icons.add),
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
