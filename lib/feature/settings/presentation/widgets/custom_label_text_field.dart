import 'package:flutter/material.dart';

class CustomLabelTextField extends StatelessWidget {
  const CustomLabelTextField({
    super.key,
    required this.name,
    required this.controller,
    this.isRequired = false,
    this.horizontalPadding = 16,
    this.verticalPadding = 14,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final String name;
  final TextEditingController controller;
  final bool isRequired;
  final double horizontalPadding;
  final double verticalPadding;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: name,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
          ),
        ),
      ],
    );
  }
}