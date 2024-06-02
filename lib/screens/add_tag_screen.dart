import 'package:flutter/material.dart';

class AddTagScreen extends StatelessWidget {
  const AddTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tag'),
      ),
      body: const Center(
        child: Text('Add Tag Screen'),
      ),
    );
  }
}
