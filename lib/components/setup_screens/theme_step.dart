import 'package:finance_tracker/components/localisations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeStep extends StatefulWidget {
  const ThemeStep({super.key});

  @override
  ThemeStepState createState() => ThemeStepState();
}

class ThemeStepState extends State<ThemeStep> {
  bool? _themeGroupValue;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeGroupValue = prefs.getBool('theme') ?? true;
    });
  }

  void _handleThemeChange(bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme", value!);
    Provider.of<NexusColor>(context, listen: false).updateTheme(value);
    setState(() {
      _themeGroupValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    NexusColor nexusColor = Provider.of<NexusColor>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dark_mode, size: 100, color: nexusColor.text),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context).translate('themeSelect'),
              style: TextStyle(color: nexusColor.text, fontSize: 24)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(AppLocalizations.of(context).translate('themeLight'),
                      style: TextStyle(color: nexusColor.text)),
                  leading: Radio<bool?>(
                    value: false,
                    groupValue: _themeGroupValue,
                    onChanged: _handleThemeChange,
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).translate('themeDark'),
                      style: TextStyle(color: nexusColor.text)),
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
    );
  }
}
