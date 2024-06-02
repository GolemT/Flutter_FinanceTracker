import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color? color;

  CustomButton({
    required this.onTap,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: color ?? Color(0x60121212),
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xFFFFFFFF)))),

                  
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFAFAFA),
              fontSize: 16,
            ),
          )),
    );
  }
}
