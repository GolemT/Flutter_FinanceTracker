import 'package:finance_tracker/components/localisations.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/material.dart';

class NotificationsStep extends StatelessWidget {

  const NotificationsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final nexusColor = NexusColor();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 100, color: nexusColor.text),
            Text(AppLocalizations.of(context).translate('notifSetup'), style: TextStyle(color: nexusColor.text, fontSize: 24)),
            SwitchListTile(
              title: Text('Activate'),
              value: true,
              onChanged: (bool value) {},
            ),
          ],
        ),
      ),
    );
  }
}
