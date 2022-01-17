import 'package:flutter/material.dart';

class LookLogo extends StatelessWidget {
  LookLogo({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: height,
    );
  }
}
