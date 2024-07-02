import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:provider/provider.dart';

class PieChartComponent extends StatefulWidget {
  const PieChartComponent({super.key});

  @override
  PieChartComponentState createState() => PieChartComponentState();
}

class PieChartComponentState extends State<PieChartComponent> {
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    final fileController = context.read<FileController>();
    Map<String, double> sumsByTag = {};

    for (var tag in fileController.listTag) {
      sumsByTag[tag.tagName] = 0;
    }

    for (var transaction in fileController.listTransaction) {
      if (transaction.transactionAmount < 0) {
        for (var tag in transaction.transactionTag) {
          if (tag < fileController.listTag.length) {
            String tagName = fileController.listTag[tag].tagName;
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
    final nexusColor = NexusColor();

    return Consumer<FileController>(
      builder: (context, fileController, child) {
        return dataMap.isEmpty
            ? Text("No data available", style: TextStyle(color: nexusColor.text))
            : PieChart(
                centerTextStyle: TextStyle(color: nexusColor.text),
                animationDuration: const Duration(milliseconds: 80),
                dataMap: dataMap,
                colorList: [
                  Colors.red.withOpacity(0.7),
                  Colors.green.withOpacity(0.7),
                  Colors.blue.withOpacity(0.7),
                  NexusColor.accents,
                  NexusColor.secondary,
                  Colors.red.withOpacity(0.3),
                  Colors.green.withOpacity(0.3),
                  Colors.blue.withOpacity(0.3),
                ],
                chartType: ChartType.disc,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
          ),
        );
      }
    );
  }
}
