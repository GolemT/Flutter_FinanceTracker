import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/assets/color_theme.dart';
import 'package:finance_tracker/components/nav_bar.dart';
import 'package:finance_tracker/components/nav_model.dart';
import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:finance_tracker/screens/analytics_screen.dart';
import 'package:finance_tracker/screens/home_screen.dart';
// import 'package:finance_tracker/screens/maxs_test_screen.dart';
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
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceTracker',
      theme: NexusTheme.nexusTheme,
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
        page: AnalyticsScreen(),
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
        backgroundColor: NexusColor.secondary,
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
          color: NexusColor.text,
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