import 'package:finance_tracker/model/tag.dart';
import 'package:finance_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:finance_tracker/file_controller.dart';

// Testing Data
// [
//     Transaction(
//       "Car","2024-03-13",[2],4500.00,["Arbeit"]
//     ),
//     Transaction(
//       "Baloons","2024-03-12",[0],-40.00,["Freizeit"]
//     ),
//     Transaction(
//       "Health Insurance","2024-04-01",[3],-150.00,["Versicherung"]
//     ),
//     Transaction(
//       "Online Course on Data Science","2024-04-15",[1],-200.00,["Bildung"]
//       ),
//   ];
//   final List<Tag> tags = [Tag("Freizeit", "Freizeitausgabe"), Tag("Bildung", "Bildungsausgabe"), Tag("Arbeit", "Arbeitsausgabe"), Tag("Versicherung", "Versicherungsausgabe")];

class MyChart extends StatefulWidget {
  final List<Transaction> transactions = FileController().listTransaction;
  final List<Tag> tags = FileController().listTag;
  final ThemeData themeMode = ThemeData();

  MyChart({Key? key});

  @override
  _MyChartState createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    Map<String, double> sumsByTag = {};

    for (var tag in widget.tags) {
      sumsByTag[tag.tagName] = 0;
    }

    for (var transaction in widget.transactions) {
      if (transaction.transactionAmount < 0) {
        for (var tag in transaction.transactionTag) {
          if(tag < widget.tags.length) {
            String tagName = widget.tags[tag].tagName;
            if (sumsByTag.containsKey(tagName)) {
            sumsByTag[tagName] = sumsByTag[tagName]! + transaction.transactionAmount;
          }
          }
        }
      }
    }
    sumsByTag.removeWhere((key, value) => value >= 0);

    setState(() {
      dataMap = sumsByTag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return dataMap.isEmpty
        ? const Text("No data available")
        : PieChart(
            dataMap: dataMap,
            colorList: [
              Colors.red.withOpacity(0.7),
              Colors.green.withOpacity(0.7),
              Colors.blue.withOpacity(0.7),
            ],
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValueBackground: false,
              chartValueStyle: TextStyle(color: widget.themeMode.textTheme.bodyLarge?.color),
            ),
            chartType: ChartType.disc,
          );
  }
}
