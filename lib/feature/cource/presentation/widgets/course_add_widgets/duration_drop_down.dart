
import 'package:flutter/material.dart';

class DurationDropdown extends StatelessWidget {
  const DurationDropdown({super.key, required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    const List<String> durations = [
  '1 Month',
  '3 Months',
  '6 Months',
  '1 Year',
];
    return DropdownButtonFormField<String>(
      initialValue: selected,
      isExpanded: true,
      hint: Text(
        'Select Duration',
        style: TextStyle(
            color: Colors.grey.shade400, fontStyle: FontStyle.italic),
      ),
      decoration: _dropdownDecoration(),
      items: durations
          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
          .toList(),
      onChanged: onChanged,
    );
  }
}


InputDecoration _dropdownDecoration() {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}