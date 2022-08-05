import 'package:flutter/material.dart';

class Backdrop extends StatelessWidget {
  final Widget child;

  const Backdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/back.png'), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
