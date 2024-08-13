import 'package:flutter/material.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/nav_bar.dart';

class NavScreen extends StatelessWidget {
  final Widget child;
  final int pageIndex;

  const NavScreen({
    super.key,
    required this.child,
    required this.pageIndex
  });

  @override
  Widget build(BuildContext context) {
    final nexusColor = NexusColor();
    return Scaffold(
      backgroundColor: nexusColor.background,
      body: child,
      bottomNavigationBar: NavBar(
        pageIndex: pageIndex,
      ),
    );
  }
}
