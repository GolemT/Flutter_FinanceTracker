import 'package:flutter/material.dart';
import 'package:finance_tracker/components/custom_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 1.0,
      ),

      body: Container(
        color: Color(0xFF272727),
        child: ListView(
          children: <Widget>[
            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Budget',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Theme',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Language',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Notification',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Support',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'License',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Rate Us',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Buy us a Coffee',
            ),

            CustomButton(
              onTap: () {
                print('gedrückt');
              },
              text: 'Delete my Data!',
              color: Color(0x60FF0000),
            ),
          ],
        ),
      ),
    );
  }
}
