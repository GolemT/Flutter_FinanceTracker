import 'package:finance_tracker/components/locale_notifier.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:finance_tracker/components/no_animation_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  SetupScreenState createState() => SetupScreenState();
}

class SetupScreenState extends State<SetupScreen> {
  final nexusColor = NexusColor();
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

  finishSetup() async {
    prefs.setBool('isFirstRun', false);
  }

  void _handleThemeChange(bool? value) {
    setState(() {
      prefs.setBool("theme", value!);
      _themeGroupValue = value;
      NexusColor.updateTheme(value);
    });
    Navigator.push(context, NoAnimationPageRoute(builder: (context) => const SetupScreen(), settings: const RouteSettings(name: '/setup')));
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
      _selectedLanguage = value!;
      if (value == 'English') {
        context.read<LocaleNotifier>().setLocale(const Locale('en'));
      } else if (value == 'Deutsch') {
        context.read<LocaleNotifier>().setLocale(const Locale('de'));
      }
      prefs.setString('lang', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('setupTitle'), style: TextStyle(color: nexusColor.text)),
          backgroundColor: nexusColor.navigation,
          iconTheme: IconThemeData(color: nexusColor.text),
        ),
        backgroundColor: nexusColor.background,
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('langSelect'), style: TextStyle(color: nexusColor.text, fontSize: 20.0)),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        dropdownColor: nexusColor.inputs,
                        style: TextStyle(color: nexusColor.text, fontSize: 16.0),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('themeSelect'), style: TextStyle(color: nexusColor.text, fontSize: 20.0)),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('accSetup'), style: TextStyle(color: nexusColor.text, fontSize: 20.0)),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppLocalizations.of(context).translate('notifSetup'), style: TextStyle(color: nexusColor.text, fontSize: 20.0)),
                      Text(AppLocalizations.of(context).translate('notifSelect'), style: TextStyle(color: nexusColor.text, fontSize: 16.0)),
                    ],
                  ),
                ),
              ],
            ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'SetupButton',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          label: Text(AppLocalizations.of(context).translate('finishSetup')),
          backgroundColor: NexusColor.accents,
          onPressed: () async {
            await finishSetup();
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
    );
  }
}
