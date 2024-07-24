import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:flutter/material.dart';

class FinishStep extends StatelessWidget {

  const FinishStep({super.key});

  @override
  Widget build(BuildContext context) {
    final nexusColor = NexusColor();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 200, color: NexusColor.positive),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate('done'), style: TextStyle(color: nexusColor.text, fontSize: 24)),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).translate('finishText'), style: TextStyle(color: nexusColor.text,fontSize: 16)),
          ],
        ),
      )
    );
  }
}
