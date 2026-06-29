import 'package:flutter/material.dart';

class DialogActions extends StatelessWidget {
  const DialogActions({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    this.isLoading = false,
    this.confirmLabel = 'Add',
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool isLoading;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
          ),
          child: const Text('Cancel',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isLoading ? null : onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(confirmLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}