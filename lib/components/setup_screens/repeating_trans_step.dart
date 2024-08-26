import 'package:finance_tracker/components/localisations.dart';
import 'package:finance_tracker/components/monthly_item.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/material.dart';

class RepeatStep extends StatefulWidget {
  const RepeatStep({super.key});

  @override
  RepeatStepState createState() => RepeatStepState();
}

class RepeatStepState extends State<RepeatStep> {
  final nexusColor = NexusColor();
  late SharedPreferences prefs;
  List<Transaction> listRepTransaction = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FileController>().readRepTransaction());
    _loadPreferences();
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'newTagButton',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      label: Text(AppLocalizations.of(context).translate('newMonthly')),
      icon: const Icon(Icons.add),
      backgroundColor: NexusColor.accents,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(
                    isMonthly: true,
                  )),
        );
        await context.read<FileController>().readRepTransaction();
        setState(() {});
      },
    );
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final items = fileController.listTag
        .map((tag) => MultiSelectItem<Tag>(tag, tag.tagName))
        .toList();

    return Scaffold(
        backgroundColor: nexusColor.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.event_repeat_outlined,
                    size: 100, color: nexusColor.text),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context).translate('repeatSetup'),
                    style: TextStyle(color: nexusColor.text, fontSize: 24)),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context).translate('later'),
                    style: TextStyle(color: nexusColor.subText, fontSize: 16)),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: fileController.listRepTransaction.length,
                    itemBuilder: (context, index) {
                      List<Transaction> list =
                          List.from(fileController.listRepTransaction);
                      final transaction = list[index];
                      return MonthlyItem(
                        transaction: transaction,
                        tagList: fileController.listTag,
                        items: items,
                        fileController: fileController,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
    );
  }
}
