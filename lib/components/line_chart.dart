import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/components/localisations.dart';

class LineChartComponent extends StatefulWidget {
  const LineChartComponent({super.key});

  @override
  LineChartComponentState createState() => LineChartComponentState();
}

class LineChartComponentState extends State<LineChartComponent> {
  List<FlSpot> lineChartData = [];
  List<String> xLabels = [];
  double minY = 0;
  double maxY = 0;
  late SharedPreferences prefs;
  NexusColor nexusColor = NexusColor();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    prefs = await SharedPreferences.getInstance();
    final fileController = context.read<FileController>();
    final transactions = fileController.listTransaction;

    double initialBudget = prefs.getDouble('budget') ?? 0.0;

    final dataArray = transactions
        .map((item) => {'date': item.transactionDate, 'amount': item.transactionAmount})
        .toList();
    dataArray.sort((a, b) => DateTime.parse(a['date'] as String).compareTo(DateTime.parse(b['date'] as String)));

    double cumulativeSum = initialBudget;
    double minSum = initialBudget;
    double maxSum = initialBudget;

    final sumsByDate = dataArray.map((item) {
      cumulativeSum += item['amount'] as double;
      if (cumulativeSum < minSum) minSum = cumulativeSum;
      if (cumulativeSum > maxSum) maxSum = cumulativeSum;
      return {
        'date': item['date'],
        'sum': cumulativeSum,
      };
    }).toList();

    setState(() {
      lineChartData = sumsByDate.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;
        return FlSpot(index.toDouble(), item['sum'] as double);
      }).toList();

      xLabels = sumsByDate.map((item) => item['date'] as String).toList();
      minY = minSum < 0 ? minSum : 0;
      maxY = maxSum + 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nexusColor = NexusColor();
    return Scaffold(
      backgroundColor: nexusColor.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<FileController>(
          builder: (context, fileController, child) {
            return lineChartData.isEmpty
                ? Text(AppLocalizations.of(context).translate('noData'), style: TextStyle(color: nexusColor.text))
                : lineChartData.length == 1 
                  ? Text(AppLocalizations.of(context).translate('insufData'), style: TextStyle(color: nexusColor.text)) 
                  : LineChart(
                    LineChartData(
                      minY: minY,
                      maxY: maxY,
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: (lineChartData.length / 4).ceilToDouble(),
                          getTitles: (value) {
                            int index = value.toInt();
                            if (index >= 0 && index < xLabels.length) {
                              return xLabels[index];
                            } else {
                              return '';
                            }
                          },
                          getTextStyles: (context, value) => TextStyle(
                            color: nexusColor.text,
                            fontSize: 12,
                          ),
                          margin: 8,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 1,
                          getTitles: (value) {
                            if (value == minY || value == maxY || value == 0) {
                              return value.toStringAsFixed(2);
                            }
                            return '';
                          },
                          getTextStyles: (context, value) => TextStyle(
                            color: nexusColor.text,
                            fontSize: 12,
                          ),
                          margin: 8,
                        ),
                        topTitles: SideTitles(showTitles: false),
                        rightTitles: SideTitles(showTitles: false),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: nexusColor.divider,
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: nexusColor.divider,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: nexusColor.divider),
                          bottom: BorderSide(color: nexusColor.divider),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: lineChartData,
                          isCurved: false,
                          colors: [NexusColor.secondary],
                          barWidth: 2,
                          belowBarData: BarAreaData(
                            show: false,
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
