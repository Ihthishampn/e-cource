import 'package:flutter/material.dart';

class UploadField extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;

  const UploadField({super.key, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline, color: Colors.grey),
            const SizedBox(width: 10),
            Text(hint, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}