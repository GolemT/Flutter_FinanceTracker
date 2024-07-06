import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_theme.dart';
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


Future themePicker () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('theme') == null) {
    prefs.setBool('theme', true);
    NexusColor.updateTheme(true);
  }
  if(prefs.getDouble('budget') == null){
    prefs.setDouble('budget', 0.0);
  }
  else {
    final entry = prefs.getBool('theme');
    NexusColor.updateTheme(entry!);
  }
  return;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FutureBuilder(
      future: themePicker(),
      builder: (context, snapshot) {
        return const CircularProgressIndicator();
      },
    );

    return MaterialApp(
      title: 'Finance Tracker',
      initialRoute: '/home',
      theme: NexusTheme().nexusTheme,
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
