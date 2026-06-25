import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Size size;
  const CustomButton({super.key, required this.title, required this.size});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize:  WidgetStatePropertyAll(size),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        backgroundColor: const WidgetStatePropertyAll(
          Color.fromARGB(255, 10, 22, 53),
        ),
      ),
      onPressed: () {},
      child:  Text(
        title,
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}
