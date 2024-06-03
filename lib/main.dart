import 'package:finance_tracker/components/nav_model.dart';
import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:finance_tracker/screens/analytics_screen.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:finance_tracker/screens/settings_screen.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:flutter/material.dart';

import 'components/nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF272727),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
          bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
          bodySmall: TextStyle(color: Color(0xFFFFFFFF)),
          displayLarge: TextStyle(color: Color(0xFFFFFFFF)),
          displayMedium: TextStyle(color: Color(0xFFFFFFFF)),
          displaySmall: TextStyle(color: Color(0xFFFFFFFF)),
          titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
          titleMedium: TextStyle(color: Color(0xFFFFFFFF)),
          titleSmall: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final tagsNavKey = GlobalKey<NavigatorState>();
  final addTransactionNavKey = GlobalKey<NavigatorState>();
  final analyticsNavKey = GlobalKey<NavigatorState>();
  final settingsNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: const HomeScreen(),
        navKey: homeNavKey,
      ),
      NavModel(
        page: const TagsScreen(),
        navKey: tagsNavKey,
      ),
      NavModel(
        page: const AddTransactionScreen(),
        navKey: addTransactionNavKey,
      ),
      NavModel(
        page: const AnalyticsScreen(),
        navKey: analyticsNavKey,
      ),
      NavModel(
        page: const SettingsScreen(),
        navKey: settingsNavKey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: items
            .map((page) => Navigator(
                  key: page.navKey,
                  onGenerateInitialRoutes: (navigator, initialRoute) {
                    return [MaterialPageRoute(builder: (context) => page.page)];
                  },
                ))
            .toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.blue,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () {
          final addTransactionModelIndex = items.indexWhere((element) => element.page.runtimeType == AddTransactionScreen);
          if (addTransactionModelIndex != -1) {
            // Navigate to AddTransactionScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
            );
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
        onTap: (index) {
          if (index == selectedTab) {
            items[index];
          } else {
            setState(() {
              selectedTab = index;
            });
          }
        },
      ),
    );
  }
}