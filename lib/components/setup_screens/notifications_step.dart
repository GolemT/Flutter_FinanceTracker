import 'package:finance_tracker/components/localisations.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsStep extends StatefulWidget {
  const NotificationsStep({super.key});

  @override
  NotificationsStepState createState() => NotificationsStepState();
}

class NotificationsStepState extends State<NotificationsStep> {
  
  bool _isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('daily_notification', false);
    setState(() {
      _isNotificationEnabled = prefs.getBool('daily_notification') ?? false;
    });
  }

  final notificationService = NotificationService();

  void _toggleNotification(bool value) async {
    setState(() {
      _isNotificationEnabled = value;
    });
    await notificationService.toggleNotification(value);
  }

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
            Text(
              AppLocalizations.of(context).translate('notifSetup'),
              style: TextStyle(color: nexusColor.text, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0, right: 50, top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Platzieren Sie den Text und den Schalter mit Abstand
                children: [
                  Text(
                    AppLocalizations.of(context).translate('notifDeac'),
                    style: TextStyle(color: nexusColor.text),
                  ),
                  Switch(
                    value: _isNotificationEnabled,
                    onChanged: (value) => _toggleNotification(value),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('notifAc'),
                    style: TextStyle(color: nexusColor.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
