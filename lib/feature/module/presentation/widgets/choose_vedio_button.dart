import 'package:flutter/material.dart';

class ChooseVideoButton extends StatelessWidget {
  final VoidCallback onTap;

  const ChooseVideoButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.grey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        height: 42,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text("Choose Video", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
