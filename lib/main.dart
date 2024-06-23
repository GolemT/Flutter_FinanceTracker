import 'package:finance_tracker/assets/color_theme.dart';
import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:finance_tracker/screens/analytics_screen.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:finance_tracker/screens/settings_screen.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FileController()),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceTracker',
      theme: NexusTheme.nexusTheme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/tags': (context) => const TagsScreen(),
        '/addTransaction': (context) => const AddTransactionScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
