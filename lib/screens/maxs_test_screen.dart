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
        title: Text('Tests, Enttäuschungen und Einhörner'),
      ),
      body: Column(
        children: [
          Consumer<FileController>(
            builder: (context, fileController, child) {
              try {
                return Text(
                  fileController.listTransaction[1].transactionName + " " + fileController.listTransaction[1].transactionAmount.toString() + " " + fileController.listTransaction[1].transactionTagName.toString()
                );
                }catch(e){
                  return Text("FUCK");
                }
              },
            ),
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Für was hasts verwendt',
              ),
            ),
                        TextField(
              controller: controllerAmount,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'WIE VIEL???',
              ),
            ),
            
            TextButton(
              onPressed: () {
                context.read<FileController>().createTransaction(controllerName.text, "gestern", [0, 1], double.parse(controllerAmount.text));
              },
              child: Text('Speichern'),
            ),
            TextButton(
              onPressed: () {
                context.read<FileController>().resetTransaction();
              },
              child: Text('Reset'),
            ),
                        Consumer<FileController>(
              builder: (context, fileController, child) {
                try{
                return Text(
                  fileController.listTag[1].tagName
                );
                }catch(e){
                  return Text("FUCK");
                }
              },
            ),
            TextField(
              controller: controllerTag,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'N suber doller dag',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<FileController>().createTag(controllerTag.text, "Desgribdschön");
              },
              child: Text('Speichern'),
            ),
            TextButton(
              onPressed: () {
                context.read<FileController>().resetTag();
              },
              child: Text('Reset Tag'),
            ),
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'N suber doller dag',
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<FileController>().updateTransaction(1, controllerName.text, "gestern", [0, 1], double.parse("55"));
              },
              child: Text('update Transaction'),
            ),
            TextButton(
              onPressed: () {
                context.read<FileController>().deleteTransaction(1);
              },
              child: Text('delete Transaction'),
            ),
            TextButton(
              onPressed: () {
                context.read<FileController>().deleteTag(1);
              },
              child: Text('delete Tag'),
            ),
            Image.asset(
              'assets/einhorn.jpg',
            )

          ],
        ),
      ),
    );
  }
}
