import 'package:flutter/material.dart';

class SelectionItemSettings extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback ontap;
  const SelectionItemSettings({
    super.key,
    required this.text,
    required this.ontap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: .bold),
        ),
      ),
    );
  }
}
