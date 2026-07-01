import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final String name;
  final VoidCallback ontap;
  final IconData icon;
  const ButtonWithIcon({super.key, required this.name, required this.ontap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: ontap,
      icon:  Icon(icon, size: 16, color: Colors.white),
      label: Text(name, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
