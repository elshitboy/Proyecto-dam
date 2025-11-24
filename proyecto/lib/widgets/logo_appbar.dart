import 'package:flutter/material.dart';

class LogoAppbar extends StatelessWidget {
  const LogoAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.asset(
        'assets/images/Logo.png',
        fit: BoxFit.contain,
        scale: 14,
      ),
    );
  }
}
