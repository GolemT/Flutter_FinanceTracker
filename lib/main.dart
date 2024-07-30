import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_theme.dart';
import 'package:finance_tracker/screens/analytics_screen.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:finance_tracker/screens/settings_screen.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:finance_tracker/screens/setup_screen.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finance_tracker/components/locale_notifier.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {

  Workmanager().executeTask((task, inputData) async {
    
    final  fileController = FileController();

    await fileController.performTask();

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager().registerOneOffTask(
      "oneoff-task", 
      "test-task"
  );

  Workmanager().registerPeriodicTask(
    "1",
    "repeatingTransaction",
    frequency: const Duration(days: 1),
  );

  runApp(
    MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => NexusColor()),
      ChangeNotifierProvider(create: (context) => FileController()),
      ChangeNotifierProvider(create: (context) => LocaleNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<bool> firstRunCheck() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  return isFirstRun;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: firstRunCheck(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          bool isFirstRun = snapshot.data ?? true;
          return Consumer<LocaleNotifier>(
            builder: (context, localeNotifier, _) {
              return MaterialApp(
                title: 'Finance Tracker',
                locale: localeNotifier.locale,
                supportedLocales: const [
                  Locale('en', ''),
                  Locale('de', ''),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  if (locale == null) {
                    return supportedLocales.first;
                  }
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale.languageCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                initialRoute: isFirstRun ? '/setup' : '/home',
                theme: NexusTheme().nexusTheme,
                routes: {
                  '/home': (context) => const HomeScreen(),
                  '/tags': (context) => const TagsScreen(),
                  '/addTransaction': (context) => const AddTransactionScreen(),
                  '/analytics': (context) => const AnalyticsScreen(),
                  '/settings': (context) => const SettingsScreen(),
                  '/setup': (context) => const SetupScreen(),
                },
              );
            },
          );
        }
      },
    );
  }
}
