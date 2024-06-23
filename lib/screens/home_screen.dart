import 'package:flutter/material.dart';
import 'package:finance_tracker/components/nav_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavScreen(
      pageIndex: 0,
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
      child: const Center(
          child: Text("Home Screen"),
        ),
    );
  }
}
