import 'package:finance_tracker/components/line_chart.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/pie_chart.dart';

class AnalyticsScreen extends StatelessWidget {

  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = Theme.of(context);

    return NavScreen(
      pageIndex: 3,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/tags');
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30), // Padding am oberen Rand
              Card(
                color: themeMode.inputDecorationTheme.fillColor,
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cost by Tag",
                        style: themeMode.textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: 300, // Feste Höhe für das Pie Chart
                        child: PieChartComponent(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: themeMode.inputDecorationTheme.fillColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Banking History",
                        style: themeMode.textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: 250, // Feste Höhe für das Line Chart
                        child: LineChartComponent(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
