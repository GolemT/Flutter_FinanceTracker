import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  TestScreen({super.key});
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerAmount = TextEditingController();
  final TextEditingController controllerTag = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Column(
        children: [
          Consumer<FileController>(
            builder: (context, fileController, child) {
              try {
                return Text(
                    "${fileController.listTransaction[1].transactionName} ${fileController.listTransaction[1].transactionAmount} ${fileController.listTransaction[1].transactionTagName}");
              } catch (e) {
                return const Text("FUCK");
              }
            },
          ),
          TextField(
            controller: controllerName,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Für was hasts verwendt',
            ),
          ),
          TextField(
            controller: controllerAmount,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'WIE VIEL???',
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<FileController>().createTransaction(
                  controllerName.text,
                  "gestern",
                  [0, 1],
                  double.parse(controllerAmount.text));
            },
            child: const Text('Speichern'),
          ),
          TextButton(
            onPressed: () {
              context.read<FileController>().resetTransaction();
            },
            child: const Text('Reset'),
          ),
          Consumer<FileController>(
            builder: (context, fileController, child) {
              try {
                return Text(fileController.listTag[1].tagName);
              } catch (e) {
                return const Text("FUCK");
              }
            },
          ),
          TextField(
            controller: controllerTag,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'N suber doller dag',
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<FileController>().createTag(
                  controllerTag.text, "Hier is oane suber dolle bschreibung");
            },
            child: const Text('Speichern'),
          ),
          TextButton(
            onPressed: () {
              context.read<FileController>().resetTag();
            },
            child: const Text('Reset Tag'),
          ),
          Image.asset(
            'assets/einhorn.jpg',
          )
        ],
      ),
    );
  }
}
