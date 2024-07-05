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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final String patreon = 'https://www.patreon.com/NexusCode';
  final String appStore = "";
  late SharedPreferences prefs;
  bool? _themeGroupValue;
  late TextEditingController _budgetController;
  String account = "";

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

  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    final nexusColor = NexusColor();

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
                          label: Text("Account Budget", style: TextStyle(color: nexusColor.text)),
                          hintText: "Enter your budget",
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
              title: Text('Theme', style: TextStyle(color: nexusColor.text, fontSize: 18.0)),
              leading: Icon(Icons.mode_night_outlined, color: nexusColor.text,),
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
            leading: Icon(Icons.translate, color: nexusColor.text,),
          ),
          ListTile(
            title: Text('Notifications', style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.notifications, color: nexusColor.text,),
          ),
          ListTile(
            title: Text('Support/FAQ', style: TextStyle(color: nexusColor.text)),
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
            title: Text('License', style: TextStyle(color: nexusColor.text)),
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
            title: Text('Buy us a Coffee <3', style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.coffee_outlined, color: nexusColor.text,),
            onTap: () async {
              await EasyLauncher.url(url: patreon);
            },
          ),
          ListTile(
            title: Text('Rate us!', style: TextStyle(color: nexusColor.text)),
            leading: Icon(Icons.star, color: nexusColor.text,),
            onTap: () async {
              await EasyLauncher.url(url: appStore);
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

                          prefs.remove('theme');
                          prefs.remove('budget');

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

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
}
