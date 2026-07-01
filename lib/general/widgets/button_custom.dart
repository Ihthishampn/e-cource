import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onTap;
  final IconData? icon;

  const CustomElevatedButton({
    super.key,
    required this.name,
    required this.color,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: icon != null
          ? Icon(
              icon,
              color: Colors.white,
              size: 18,
            )
          : const SizedBox.shrink(),
      label: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}