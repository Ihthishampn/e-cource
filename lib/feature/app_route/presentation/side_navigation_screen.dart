import 'package:flutter/material.dart';

class SideNavigationScreen extends StatelessWidget {
  final Widget child;
  const SideNavigationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: const Drawer(), body: child);
  }
}
