import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:finance_tracker/components/monthly_item.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  MonthlyScreenState createState() => MonthlyScreenState();
}

class MonthlyScreenState extends State<MonthlyScreen> {
  List<Transaction> listRepTransaction = [];

  @override
  void initState() {
    super.initState();
    // Loading the tags initially when the screen is created
    Future.microtask(() => context.read<FileController>().readRepTransaction());
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'newTagButton',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      label: Text(AppLocalizations.of(context).translate('newTag')),
      backgroundColor: NexusColor.accents,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
        );
        await context.read<FileController>().readRepTransaction();
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final items = fileController.listTag
        .map((tag) => MultiSelectItem<Tag>(tag, tag.tagName))
        .toList();
    final nexusColor = NexusColor();

    return NavScreen(
      pageIndex: 2,
      child: SafeArea(
        child: fileController.listRepTransaction.isEmpty
            ? Scaffold(
                backgroundColor: nexusColor.background,
                body: Center(
                  child: Text(
                    AppLocalizations.of(context).translate('noMonthly'),
                    style: TextStyle(color: nexusColor.text, fontSize: 20.0),
                  ),
                ),
                floatingActionButton:_buildFloatingActionButton(context)
              )
            : Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: nexusColor.background,
                body: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: fileController.listRepTransaction.length,
                  itemBuilder: (context, index) {
                    List<Transaction> list = List.from(fileController.listRepTransaction);
                    final transaction = list[index];
                    return MonthlyItem(
                        transaction: transaction,
                        tagList: fileController.listTag,
                        items: items,
                        fileController: fileController,
                    );
                  },
                ),
                floatingActionButton: _buildFloatingActionButton(context)
              ),
      ),
    );
  }
}
