import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:flutter/material.dart';

class WelcomeStep extends StatelessWidget {

  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final nexusColor = NexusColor();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart, size: 200, color: NexusColor.accents,), //TODO: Replace with app logo
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context).translate('title'), style: TextStyle(color: nexusColor.text, fontSize: 24)),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context).translate('intro'), style: TextStyle(color: nexusColor.text,fontSize: 16)),
        ],
      ),
    );
  }
}
