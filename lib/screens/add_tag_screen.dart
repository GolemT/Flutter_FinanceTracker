import 'package:flutter/material.dart';

class AddTagScreen extends StatelessWidget {
  const AddTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Tag', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: const Center(
        child: Text('Add Tag Screen'),
      ),
    );
  }
}
