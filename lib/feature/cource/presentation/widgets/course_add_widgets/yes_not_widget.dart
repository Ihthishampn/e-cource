
import 'package:flutter/material.dart';
 
class YesNoRadioRow extends StatelessWidget {
  const YesNoRadioRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
 
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            _RadioButton(
              selected: value,
              label: 'Yes',
              onTap: () => onChanged(true),
            ),
            const SizedBox(width: 16),
            _RadioButton(
              selected: !value,
              label: 'No',
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ],
    );
  }
}



class _RadioButton extends StatelessWidget {
  const _RadioButton({
    required this.selected,
    required this.label,
    required this.onTap,
  });
 
  final bool selected;
  final String label;
  final VoidCallback onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: selected ? Colors.blue.shade800 : Colors.black54,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}