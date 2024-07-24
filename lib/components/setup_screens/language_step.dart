import 'package:finance_tracker/components/locale_notifier.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LanguageStep extends StatefulWidget {

  const LanguageStep({super.key});

  @override
  LanguageStepState createState() => LanguageStepState();
}

class LanguageStepState extends State<LanguageStep> {
  final nexusColor = NexusColor();
  late SharedPreferences prefs;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = "English";

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.translate, size: 100, color: nexusColor.text),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context).translate('langSelect'), style: TextStyle(color: nexusColor.text, fontSize: 24)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,  // Set the desired width here
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      dropdownColor: nexusColor.inputs,
                      style: TextStyle(color: nexusColor.text, fontSize: 16.0),
                      items: [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text(AppLocalizations.of(context).translate('langEn'), style: TextStyle(color: nexusColor.text, fontSize: 18)),
                        ),
                        DropdownMenuItem(
                          value: 'Deutsch',
                          child: Text(AppLocalizations.of(context).translate('langDe'), style: TextStyle(color: nexusColor.text, fontSize: 18)),
                        ),
                      ],
                      onChanged: _handleLanguageChange,
                      isExpanded: true,  // Makes the dropdown take the full width
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
