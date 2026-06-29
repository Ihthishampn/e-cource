import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogTextField extends StatelessWidget {
  const DialogTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isItalic = false,
    this.isNumber = false,
    this.suffixIcon,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool isItalic;
  final bool isNumber;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
          : null,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}