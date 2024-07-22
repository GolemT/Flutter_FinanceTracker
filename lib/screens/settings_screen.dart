import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:finance_tracker/screens/settings_subscreens/support.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/screens/settings_subscreens/license.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/components/locale_notifier.dart';
import 'package:finance_tracker/components/localisations.dart';

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
  late TextEditingController _budgetController;
  String account = "";
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeGroupValue = prefs.getBool('theme') ?? true;
      double? budget = prefs.getDouble('budget');
      account = budget?.toString() ?? "";
      _budgetController.text = account;
      _selectedLanguage = prefs.getString('lang') == 'en' ? 'English' : 'Deutsch';
    });
  }

  void _handleThemeChange(bool? value) {
    setState(() {
      prefs.setBool("theme", value!);
      _themeGroupValue = value;
      NexusColor.updateTheme(value);
    });
  }

  void _handleBudgetChange(String value) {
    setState(() {
      double? budget = double.tryParse(value);
      if (budget != null) {
        prefs.setDouble("budget", budget);
        account = value;
      }
    });
  }

    void _handleLanguageChange(String? value) {
    setState(() {
      _selectedLanguage = value;
      if (value == 'English') {
        context.read<LocaleNotifier>().setLocale(const Locale('en'));
      } else if (value == 'Deutsch') {
        context.read<LocaleNotifier>().setLocale(const Locale('de'));
      }
      prefs.setString('lang', value!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    final nexusColor = NexusColor();

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
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
            ),
            child: ExpansionTile(
              iconColor: nexusColor.text,
              collapsedIconColor: nexusColor.text,
              title: Text(AppLocalizations.of(context).translate('budget'), style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              leading: Icon(Icons.account_balance, color: nexusColor.text,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        maxLength: 15,
                        controller: _budgetController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*'),
                          ),
                        ],
                        style: TextStyle(color: nexusColor.text),
                        decoration: InputDecoration(
                          label: Text(AppLocalizations.of(context).translate('accBudget'), style: TextStyle(color: nexusColor.text)),
                          hintText: AppLocalizations.of(context).translate('accBudgetHint'),
                          filled: true,
                          fillColor: nexusColor.inputs,
                        ),
                        onChanged: (value) {
                          _handleBudgetChange(value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              prefs.remove('budget');

                              Navigator.pushReplacementNamed(
                                context,
                                '/settings',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8.0),
                              minimumSize: const Size(37, 37),
                              maximumSize: const Size(37, 37),
                              backgroundColor: NexusColor.negative,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: nexusColor.text,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 240.0),
                          ElevatedButton(
                            onPressed: () async {
                              _handleBudgetChange(_budgetController.text);

                              Navigator.pushReplacementNamed(
                                context,
                                '/settings',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8.0),
                              minimumSize: const Size(37, 37),
                              maximumSize: const Size(37, 37),
                              backgroundColor: NexusColor.positive,
                            ),
                            child: Icon(
                              Icons.check,
                              color: nexusColor.text,
                              size: 20,
                            ),
                          ),
                        ]
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
                  strokeAlign: BorderSide.strokeAlignInside,
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
                  strokeAlign: BorderSide.strokeAlignInside,
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
                  strokeAlign: BorderSide.strokeAlignInside,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('notifSelect'), style: TextStyle(color: nexusColor.text, fontSize: 16.0)),
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
            title: Text(AppLocalizations.of(context).translate('dataPurge'), style: TextStyle(color: NexusColor.negative)),
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

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        child: Text(AppLocalizations.of(context).translate('delete')),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
}
