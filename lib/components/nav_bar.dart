import 'package:finance_tracker/assets/color_palette.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        padding: const EdgeInsets.all(0),
        elevation: 0.0,
        child: Container(
          height: 60,
          color: NexusColor.navigation,
          child: Row(
            children: [

              navItem(
                Icons.home_outlined,
                pageIndex == 0,
                'Home',
                onTap: () => onTap(0),
              ),

              navItem(
                Icons.sell_outlined,
                pageIndex == 1,
                'Tags',
                onTap: () => onTap(1),
              ),

              const SizedBox(width: 80),
              
              navItem(
                Icons.analytics_outlined,
                pageIndex == 3,
                'Analytics',
                onTap: () => onTap(3),
              ),

              navItem(
                Icons.settings_outlined,
                pageIndex == 4,
                'Settings',
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
    );
  }
}

Widget navItem(IconData icon, bool selected, String text, {Function()? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? NexusColor.accents : NexusColor.subText,
            size: 30.0,
          ),
          Text(
            text,
            style: TextStyle(color: selected ? NexusColor.accents : NexusColor.subText),
          ),
        ],
      ),
    ),
  );
}
