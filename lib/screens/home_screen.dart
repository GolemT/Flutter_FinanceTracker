import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:finance_tracker/components/transaction_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final List<Tag> tagList = fileController.listTag;
    final items = tagList.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList();

    return NavScreen(
      pageIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/tags');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/addTransaction');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/analytics');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      child: fileController.listTransaction.isEmpty
          ? Center(
              child: Text(
                "No transactions available",
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            )
          : ListView.builder(
              itemCount: fileController.listTransaction.length,
              itemBuilder: (context, index) {
                List<Transaction> list = fileController.listTransaction;
                list.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
                final transaction = list[index];
                return TransactionItem(
                  transaction: transaction,
                  tagList: tagList,
                  items: items,
                  fileController: fileController,
                );
              },
            ),
    );
  }
}
