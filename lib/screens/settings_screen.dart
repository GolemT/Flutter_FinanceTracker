import 'package:flutter/material.dart';
import 'package:finance_tracker/components/nav_screen.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/file_controller.dart';
import 'package:finance_tracker/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences prefs;
  bool? _themeGroupValue;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeGroupValue = prefs.getBool('theme') ?? true;
    });
  }

  void _handleThemeChange(bool? value) {
    setState(() {
      prefs.setBool("theme", value!);
      _themeGroupValue = value;
      NexusColor.updateTheme(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    final nexusColor = NexusColor();
    _loadPreferences();

    return NavScreen(
      pageIndex: 4,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/tags');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/analytics');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
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
              title: Text('Budget', style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        maxLength: 15,
                        style: TextStyle(color: nexusColor.text),
                        decoration: InputDecoration(
                          label: Text("Account Budget", style: TextStyle(color: nexusColor.text)),
                          hintText: "Enter your budget",
                          filled: true,
                          fillColor: nexusColor.inputs,
                        ),
                        onChanged: (value) {
                          prefs.setString('budget', value);
                        },
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
              title: Text('Theme', style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text('Light Theme', style: TextStyle(color: nexusColor.text)),
                        leading: Radio<bool?>(
                          value: false,
                          groupValue: _themeGroupValue,
                          onChanged: _handleThemeChange,
                        ),
                      ),
                      ListTile(
                        title: Text('Dark Theme', style: TextStyle(color: nexusColor.text)),
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
          ListTile(
            title: Text('Language', style: TextStyle(color: nexusColor.text)),
          ),
          ListTile(
            title: Text('Notifications', style: TextStyle(color: nexusColor.text)),
          ),
          ListTile(
            title: Text('Support', style: TextStyle(color: nexusColor.text)),
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
          ),
          ListTile(
            title: Text('License', style: TextStyle(color: nexusColor.text)),
            onTap: () {
              Navigator.pushNamed(context, '/License');
            },
          ),
          ListTile(
            title: Text('Buy us a Coffee <3', style: TextStyle(color: nexusColor.text)),
            onTap: () {
              // Navigate to Patreon
            },
          ),
          ListTile(
            title: Text('Rate us!', style: TextStyle(color: nexusColor.text)),
            onTap: () {
              // Navigate app store
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: NexusColor.negative),
            title: const Text('Delete all Data', style: TextStyle(color: NexusColor.negative)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete all Data', style: TextStyle(color: nexusColor.text)),
                    content: Text('Are you sure you want to delete all data? This action cannot be undone.', style: TextStyle(color: nexusColor.text)),
                    backgroundColor: nexusColor.background,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await fileController.resetTransaction();
                          await fileController.resetTag();
                          await fileController.refreshTagsAndTransactions();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        },
                        child: const Text('Delete'),
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
}
