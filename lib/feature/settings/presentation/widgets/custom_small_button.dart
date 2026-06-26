import 'package:flutter/material.dart';

class CustomSmallButtonSettings extends StatelessWidget {
  final VoidCallback ontap;
  const CustomSmallButtonSettings({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        ),
        child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
