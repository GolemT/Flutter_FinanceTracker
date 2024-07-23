import 'package:finance_tracker/components/localisations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class BudgetStep extends StatefulWidget {

  const BudgetStep({super.key});

  @override
  BudgetStepState createState() => BudgetStepState();

}

class BudgetStepState extends State<BudgetStep> {
  final nexusColor = NexusColor();
  late SharedPreferences prefs;
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
      double? budget = prefs.getDouble('budget');
      account = budget?.toString() ?? "";
      _budgetController.text = account;
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 100, color: nexusColor.text),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate('accSetup'), style: TextStyle(color: nexusColor.text, fontSize: 24)),
            const SizedBox(height: 20),
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
                    ],
                  ),
                ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate('budgetExplain'), style: TextStyle(color: nexusColor.text,fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
