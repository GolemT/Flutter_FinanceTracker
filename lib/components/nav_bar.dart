import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/components/no_animation_route.dart';
import 'package:finance_tracker/screens/analytics_screen.dart';
import 'package:finance_tracker/screens/settings_screen.dart';
import 'package:finance_tracker/screens/tags_screen.dart';
import 'package:finance_tracker/screens/home_screen.dart';

class NavBar extends StatelessWidget {
  final nexusColor = NexusColor();
  final int pageIndex;

  NavBar({
    super.key,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    void onTap(int index) {
      switch (index) {
        case 0:
          Navigator.push(context, NoAnimationPageRoute(builder: (context) => const HomeScreen(), settings: const RouteSettings(name: '/home')));
          break;
        case 1:
          Navigator.push(context, NoAnimationPageRoute(builder: (context) => const TagsScreen(), settings: const RouteSettings(name: '/tags')));
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/addTransaction');
          break;
        case 3:
          Navigator.push(context, NoAnimationPageRoute(builder: (context) => const AnalyticsScreen(), settings: const RouteSettings(name: '/analytics')));
          break;
        case 4:
          Navigator.push(context, NoAnimationPageRoute(builder: (context) => const SettingsScreen(), settings: const RouteSettings(name: '/settings')));
          break;
      }
    }

    return BottomAppBar(
        padding: const EdgeInsets.all(0),
        elevation: 0.0,
        child: Container(
          height: 60,
          color: nexusColor.navigation,
          child: Row(
            children: [

              navItem(
                Icons.home_outlined,
                pageIndex == 0,
                AppLocalizations.of(context).translate('home'),
                nexusColor,
                onTap: () => onTap(0),
              ),

              navItem(
                Icons.sell_outlined,
                pageIndex == 1,
                AppLocalizations.of(context).translate('tags'),
                nexusColor,
                onTap: () => onTap(1),
              ),

              const SizedBox(width: 80),
              
              navItem(
                Icons.analytics_outlined,
                pageIndex == 3,
                AppLocalizations.of(context).translate('analytics'),
                nexusColor,
                onTap: () => onTap(3),
              ),

              navItem(
                Icons.settings_outlined,
                pageIndex == 4,
                AppLocalizations.of(context).translate('settings'),
                nexusColor,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
    );
  }
}

Widget navItem(IconData icon, bool selected, String text, NexusColor nexusColor, {Function()? onTap}) {

  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? NexusColor.accents : nexusColor.subText,
            size: 30.0,
          ),
          Text(
            text,
            style: TextStyle(color: selected ? NexusColor.accents : nexusColor.subText, fontSize: 12.0),
          ),
        ],
      ),
    ),
  );
}
