import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:finance_tracker/notification_service.dart';
import 'package:finance_tracker/screens/settings_subscreens/support.dart';
import 'package:finance_tracker/screens/settings_subscreens/license.dart';
import 'package:finance_tracker/components/locale_notifier.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/screens/setup_screen.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();

}


class SettingsScreenState extends State<SettingsScreen> {
  final String patreon = 'https://www.patreon.com/NexusCode';
  // TODO: Add App Store URL
  final String appStore = "";
  late SharedPreferences prefs;
  bool? _themeGroupValue;
  String? _selectedLanguage;

  final notificationService = NotificationService();

  bool _isNotificationEnabled = false;

  void _toggleNotification(bool value) async {
    setState(() {
      _isNotificationEnabled = value;
    });
    await notificationService.toggleNotification(value);
  }
  
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeGroupValue = prefs.getBool('theme') ?? true;
      _selectedLanguage = prefs.getString('lang') == 'en' ? 'English' : 'Deutsch';
      _isNotificationEnabled = prefs.getBool('daily_notification') ?? false;

    });
  }

  void _handleThemeChange(bool? value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme", value!);
    if(mounted){
      Provider.of<NexusColor>(context, listen: false).updateTheme(value);
    }
    setState(() {
      _themeGroupValue = value;
    });
  }

  void _handleLanguageChange(String? value) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = value;
      if (value == 'English') {
        context.read<LocaleNotifier>().setLocale(const Locale('en'));
      } else if (value == 'Deutsch') {
        context.read<LocaleNotifier>().setLocale(const Locale('de'));
      }
      prefs.setString('lang', value!);
    });
  }


  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    final nexusColor = Provider.of<NexusColor>(context);

    return NavScreen(
      pageIndex: 4,
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: nexusColor.background,
              border: Border(
                bottom: BorderSide(
                  color: nexusColor.inputs,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
              ),
            ),
            child: ExpansionTile(
              iconColor: nexusColor.text,
              collapsedIconColor: nexusColor.text,
              title: Text(AppLocalizations.of(context).translate('theme'), style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              leading: Icon(Icons.mode_night_outlined, color: nexusColor.text,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(AppLocalizations.of(context).translate('themeLight'), style: TextStyle(color: nexusColor.text)),
                        leading: Radio<bool?>(
                          value: false,
                          groupValue: _themeGroupValue,
                          onChanged: _handleThemeChange,
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).translate('themeDark'), style: TextStyle(color: nexusColor.text)),
                        leading: Radio<bool?>(
                          value: true,
                          groupValue: _themeGroupValue,
                          onChanged: _handleThemeChange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: nexusColor.background,
              border: Border(
                bottom: BorderSide(
                  color: nexusColor.inputs,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
              ),
            ),
            child: ExpansionTile(
              iconColor: nexusColor.text,
              collapsedIconColor: nexusColor.text,
              title: Text(AppLocalizations.of(context).translate('lang'), style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              leading: Icon(Icons.translate, color: nexusColor.text,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('langSelect'), style: TextStyle(color: nexusColor.text, fontSize: 16.0)),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        dropdownColor: nexusColor.inputs,
                        items: [
                          DropdownMenuItem(
                            value: 'English',
                            child: Text(AppLocalizations.of(context).translate('langEn')),
                          ),
                          DropdownMenuItem(
                            value: 'Deutsch',
                            child: Text(AppLocalizations.of(context).translate('langDe')),
                          ),
                        ],
                        onChanged: _handleLanguageChange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // TODO: Implement Notification
          Container(
            decoration: BoxDecoration(
              color: nexusColor.background,
              border: Border(
                bottom: BorderSide(
                  color: nexusColor.inputs,
                  style: BorderStyle.solid,
                  width: 1.0,
                ),
              ),
            ),
            child: ExpansionTile(
              iconColor: nexusColor.text,
              collapsedIconColor: nexusColor.text,
              title: Text(AppLocalizations.of(context).translate('notif'), style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              leading: Icon(Icons.notifications, color: nexusColor.text,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 70.0, right: 50, top: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      Text(
                          AppLocalizations.of(context).translate('notifDeac'),
                          style: TextStyle(color: nexusColor.text),
                        ),
            
                      Switch(
                        value: _isNotificationEnabled,
                        onChanged: (value) => _toggleNotification(value),
                      ),
                      Text(
  	                    AppLocalizations.of(context).translate('notifAc'),
                        style: TextStyle(color: nexusColor.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate('support'), style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.support_agent, color: nexusColor.text,),
            trailing: Icon(Icons.arrow_forward_ios, color: nexusColor.text,),
            onTap: () async {
              await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SupportScreen())
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate('license'), style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.gavel, color: nexusColor.text,),
            trailing: Icon(Icons.arrow_forward_ios, color: nexusColor.text,),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LicenseScreen()),
              );
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate('weArePoorGiveUsMoney'), style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.coffee_outlined, color: nexusColor.text,),
            trailing: Icon(Icons.language, color: nexusColor.text),
            onTap: () async {
              await EasyLauncher.url(url: patreon);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate('rateUs'), style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.star, color: nexusColor.text,),
            trailing: Icon(Icons.language, color: nexusColor.text),
            onTap: () async {
              await EasyLauncher.url(url: appStore);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: NexusColor.negative),
            title: Text(AppLocalizations.of(context).translate('dataPurge'), style: const TextStyle(color: NexusColor.negative)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).translate('dataPurge'), style: TextStyle(color: nexusColor.text)),
                    content: Text(AppLocalizations.of(context).translate('dataPurgeConfirmation'), style: TextStyle(color: nexusColor.text)),
                    backgroundColor: nexusColor.background,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context).translate('cancel')),
                      ),
                      TextButton(
                        onPressed: () async {
                          await fileController.resetTransaction();
                          await fileController.resetTag();
                          await fileController.refreshTagsAndTransactions();

                          prefs.remove('theme');
                          prefs.remove('budget');
                          prefs.remove('lang');
                          prefs.remove('isFirstRun');

                          if(context.mounted){
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const SetupScreen()),
                          );
                          }
                        },
                        child: Text(AppLocalizations.of(context).translate('delete')),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // THIS IS A TEST BUTTON TO ADD TEST DATA
          //
          // ListTile(
          //   title: Text("Test Data", style: TextStyle(color: nexusColor.text)),
          //   leading: Icon(Icons.data_array, color: nexusColor.text,),
          //   onTap: () async {
          //     List<Map<String, String>> testTags = [
          //       {"tagName": "Essen", "tagDescription": "Ausgaben für Lebensmittel"},
          //       {"tagName": "Transport", "tagDescription": "Kosten für öffentliche Verkehrsmittel und Benzin"},
          //       {"tagName": "Miete", "tagDescription": "Monatliche Miete"},
          //       {"tagName": "Gehalt", "tagDescription": "Monatliches Gehalt"},
          //       {"tagName": "Freizeit", "tagDescription": "Ausgaben für Freizeitaktivitäten"},
          //       {"tagName": "Sparen", "tagDescription": "Monatliches Sparen"},
          //       {"tagName": "Geschenke", "tagDescription": "Ausgaben für Geschenke"},
          //       {"tagName": "Bildung", "tagDescription": "Ausgaben für Bildung und Bücher"},
          //       {"tagName": "Reisen", "tagDescription": "Kosten für Reisen und Urlaube"},
          //       {"tagName": "Sonstiges", "tagDescription": "Sonstige Ausgaben"}
          //     ];

          //     for (var tag in testTags) {
          //       await fileController.createTag(tag['tagName']!, tag['tagDescription']!);
          //     }

          //     List<Map<String, dynamic>> testTransactions = [
          //       {"transactionName": "Einkauf", "transactionDate": "2022-01-01", "transactionTag": [0], "transactionAmount": -50.0},
          //       {"transactionName": "Gehalt", "transactionDate": "2022-01-01", "transactionTag": [3], "transactionAmount": 2000.0},
          //       {"transactionName": "Kino", "transactionDate": "2022-01-01", "transactionTag": [4], "transactionAmount": -10.0},
          //       {"transactionName": "Sparen", "transactionDate": "2022-01-01", "transactionTag": [5], "transactionAmount": -200.0},
          //       {"transactionName": "Geschenk", "transactionDate": "2022-01-01", "transactionTag": [6], "transactionAmount": -30.0},
          //       {"transactionName": "Buch", "transactionDate": "2022-01-01", "transactionTag": [7], "transactionAmount": -20.0},
          //       {"transactionName": "Flug", "transactionDate": "2022-01-01", "transactionTag": [8], "transactionAmount": -300.0},
          //       {"transactionName": "Sonstiges", "transactionDate": "2022-01-01", "transactionTag": [9], "transactionAmount": -40.0},
          //       {"transactionName": "Einkauf", "transactionDate": "2022-02-01", "transactionTag": [0], "transactionAmount": -50.0},
          //       {"transactionName": "Gehalt", "transactionDate": "2022-02-01", "transactionTag": [3], "transactionAmount": 2000.0},
          //       {"transactionName": "Kino", "transactionDate": "2022-02-01", "transactionTag": [4], "transactionAmount": -10.0},
          //       {"transactionName": "Sparen", "transactionDate": "2022-02-01", "transactionTag": [5], "transactionAmount": -200.0},
          //       {"transactionName": "Geschenk", "transactionDate": "2022-02-01", "transactionTag": [6], "transactionAmount": -30.0},
          //       {"transactionName": "Buch", "transactionDate": "2022-02-01", "transactionTag": [7], "transactionAmount": -20.0},
          //       {"transactionName": "Flug", "transactionDate": "2022-02-01", "transactionTag": [8], "transactionAmount": -300.0},
          //       {"transactionName": "Sonstiges", "transactionDate": "2022-02-01", "transactionTag": [9], "transactionAmount": -40.0},
          //       {"transactionName": "Einkauf", "transactionDate": "2022-03-01", "transactionTag": [0], "transactionAmount": -50.0},
          //       {"transactionName": "Gehalt", "transactionDate": "2022-03-01", "transactionTag": [3], "transactionAmount": 2000.0},
          //       {"transactionName": "Kino", "transactionDate": "2022-03-01", "transactionTag": [4], "transactionAmount": -10.0},
          //       {"transactionName": "Sparen", "transactionDate": "2022-03-01", "transactionTag": [5], "transactionAmount": -200.0},
          //       {"transactionName": "Geschenk", "transactionDate": "2022-03-01", "transactionTag": [6], "transactionAmount": -30.0},
          //       {"transactionName": "Buch", "transactionDate": "2022-03-01", "transactionTag": [7], "transactionAmount": -20.0},
          //       {"transactionName": "Flug", "transactionDate": "2022-03-01", "transactionTag": [8], "transactionAmount": -300.0},
          //       {"transactionName": "Sonstiges", "transactionDate": "2022-03-01", "transactionTag": [9], "transactionAmount": -40.0}
          //     ];

          //     for (var transaction in testTransactions) {
          //       await fileController.createTransaction(
          //         transaction['transactionName'],
          //         transaction['transactionDate'],
          //         transaction['transactionTag'],
          //         transaction['transactionAmount'],
          //         false  // `repeat` parameter set to false for simplicity
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
