import 'package:finance_tracker/components/setup_screens/notifications_step.dart';
import 'package:finance_tracker/components/setup_screens/language_step.dart';
import 'package:finance_tracker/components/setup_screens/welcome_step.dart';
import 'package:finance_tracker/components/setup_screens/budget_step.dart';
import 'package:finance_tracker/components/setup_screens/finish_step.dart';
import 'package:finance_tracker/components/setup_screens/theme_step.dart';
import 'package:finance_tracker/components/localisations.dart';
import 'package:finance_tracker/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  SetupScreenState createState() => SetupScreenState();
}

class SetupScreenState extends State<SetupScreen> {
  PageController pageController = PageController();
  final nexusColor = NexusColor();
  late SharedPreferences prefs;
  int _currentPage = 0;

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _onNext() {
    if (_currentPage < 5) {
      pageController.animateToPage(_currentPage + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      pageController.animateToPage(_currentPage - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _onFinish() {
    prefs.setBool('isFirstRun', false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildIndicator(int index) {
    Color color;
    if (index == _currentPage) {
      color = NexusColor.secondary; // Active step
    } else if (index < _currentPage) {
      color = NexusColor.accents; // Completed step
    } else {
      color = nexusColor.inputs; // Not visited step
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(_buildIndicator(i));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    NexusColor nexusColor = Provider.of<NexusColor>(context);

    return Scaffold(
      backgroundColor: nexusColor.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                WelcomeStep(),
                LanguageStep(),
                ThemeStep(),
                BudgetStep(),
                NotificationsStep(),
                FinishStep(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentPage == 0
                        ? Colors.transparent
                        : NexusColor.secondary,
                  ),
                  onPressed: _currentPage == 0 ? null : _onBack,
                  child: Text(AppLocalizations.of(context).translate('back'), style: TextStyle(color: nexusColor.background)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NexusColor.secondary,
                  ),
                  onPressed: _currentPage == 5 ? _onFinish : _onNext,
                  child: _currentPage == 5
                  ? Text(AppLocalizations.of(context).translate('finish'), style: TextStyle(color: nexusColor.background))
                  : Text(AppLocalizations.of(context).translate('next'), style: TextStyle(color: nexusColor.background))
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}