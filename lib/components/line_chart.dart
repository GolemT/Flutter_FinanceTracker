import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    final fileController = context.read<FileController>();
    final transactions = fileController.listTransaction;

    final dataArray = transactions
        .map((item) => {'date': item.transactionDate, 'amount': item.transactionAmount})
        .toList();
    dataArray.sort((a, b) => DateTime.parse(a['date'] as String).compareTo(DateTime.parse(b['date'] as String)));

    double cumulativeSum = 0;
    double minSum = double.infinity;
    double maxSum = double.negativeInfinity;

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
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<FileController>(
          builder: (context, fileController, child) {
            return lineChartData.isEmpty
                ? const Text("No Data Available")
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
                            color: theme.textTheme.bodySmall?.color,
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
                            color: theme.textTheme.bodySmall?.color,
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
                            color: theme.dividerColor,
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: theme.dividerColor,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: theme.dividerColor),
                          bottom: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: lineChartData,
                          isCurved: false,
                          colors: [theme.primaryColor],
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
