import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:finance_tracker/components/transaction_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<double> _calculateTotalBalance(FileController fileController) async {
    final prefs = await SharedPreferences.getInstance();
    double budget = prefs.getDouble('budget') ?? 0.0;
    double totalBalance = budget;

    for (var transaction in fileController.listTransaction) {
      totalBalance += transaction.transactionAmount;
    }
    return totalBalance;
  }

  double _calculateTotalIncome(FileController fileController) {
    double totalIncome = 0.0;

    for (var transaction in fileController.listTransaction) {
      if (transaction.transactionAmount > 0) {
        totalIncome += transaction.transactionAmount;
      }
    }
    return totalIncome;
  }

  double _calculateTotalExpenses(FileController fileController) {
    double totalExpenses = 0.0;

    for (var transaction in fileController.listTransaction) {
      if (transaction.transactionAmount < 0) {
        totalExpenses += transaction.transactionAmount.abs();
      }
    }
    return totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final fileController = context.watch<FileController>();
    final items = fileController.listTag.map((tag) => MultiSelectItem<Tag>(tag, tag.tagName)).toList();
    final nexusColor = NexusColor();

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<double>(
              future: _calculateTotalBalance(fileController),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error calculating total balance', style: TextStyle(color: nexusColor.text, fontSize: 20));
                } else {
                  double totalBalance = snapshot.data ?? 0.0;
                  double totalIncome = _calculateTotalIncome(fileController);
                  double totalExpenses = _calculateTotalExpenses(fileController);

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(height: 20),
                        _buildCircle(
                          amount: totalBalance,
                          color: NexusColor.accents,
                          big: true,
                          context: context,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCircle(
                              amount: totalExpenses,
                              color: NexusColor.negative,
                              big: false,
                              context: context,
                            ),
                            _buildCircle(
                              amount: totalIncome,
                              color: NexusColor.positive,
                              big: false,
                              context: context,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: nexusColor.text, // Divider color
                        width: 1.0, // Divider width
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction List',
                        style: TextStyle(
                          color: nexusColor.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Wrap(
                        children: [
                          Icon(Icons.filter_alt, color: nexusColor.inputs,),
                          Icon(Icons.search, color: nexusColor.inputs,)
                        ]
                      )
                    ],
                  ),
                ),
                fileController.listTransaction.isEmpty
                    ? Center(
                        child: Text(
                          "No transactions available",
                          style: TextStyle(color: nexusColor.text, fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: fileController.listTransaction.length,
                        itemBuilder: (context, index) {
                          List<Transaction> list = fileController.listTransaction;
                          list.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
                          final transaction = list[index];
                          return TransactionItem(
                            transaction: transaction,
                            tagList: fileController.listTag,
                            items: items,
                            fileController: fileController,
                          );
                        },
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCircle({required double amount, required Color color, required bool big, required BuildContext context}) {
    return Container(
      width: big ? 160 : 100,
      height: big ? 160 : 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 4),
      ),
      child: Center(
        child: Text(
          '${amount.toStringAsFixed(2)} €',
          style: TextStyle(
            color: color,
            fontSize: big ? 24 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
