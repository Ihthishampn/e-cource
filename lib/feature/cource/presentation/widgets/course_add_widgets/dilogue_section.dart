import 'package:flutter/material.dart';

class DialogSectionRow extends StatelessWidget {
  const DialogSectionRow({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.hint,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text.rich(
              TextSpan(
                text: label,
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  if (required)
                    const TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (hint != null)
                    TextSpan(
                      text: '\n$hint',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(flex: 2, child: child),
      ],
    );
  }
}