import 'package:finance_tracker/components/linechart.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/pie_chart.dart';

class AnalyticsScreen extends StatelessWidget {

  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 300, // Feste Höhe für das Pie Chart
              child: MyChart(),
            ),
            SizedBox(
              height: 300, // Feste Höhe für das Line Chart
              child: LineChartComponent(),
            )
          ]
        )
      ),
    );
  }
}