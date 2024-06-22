import 'package:finance_tracker/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/nav_bar.dart';

class NavScreen extends StatelessWidget {
  final Widget child;
  final int pageIndex;
  final Function(int) onTap;

  const NavScreen({
    super.key,
    required this.child,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: NexusColor.secondary,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionScreen()));
        },
        child: const Icon(
          Icons.add,
          color: NexusColor.text,
        ),
      ),
      bottomNavigationBar: NavBar(
        pageIndex: pageIndex,
        onTap: onTap,
      ),
    );
  }
}
