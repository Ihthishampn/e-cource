import 'package:flutter/material.dart';

class CustomModuleDialog extends StatelessWidget {
  final String title;
  final List<String> fieldHints; // Pass multiple hints to get multiple text fields
  final Widget buttonText;
  final VoidCallback onAddPressed;
  final List<TextEditingController> controllers; // To retrieve the text later

  const CustomModuleDialog({
    super.key,
    required this.title,
    required this.fieldHints,
    required this.controllers,
   required this.buttonText,
    required this.onAddPressed,
  }) : assert(fieldHints.length == controllers.length, 
            'The number of hints must match the number of controllers.');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // 1. Fix: Makes the default dialog container invisible
      elevation: 0, // 2. Fix: Removes any shadow artifacts that create a thin outline
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0), // Rounded corners for the container
      ),
      clipBehavior: Clip.antiAlias, // Ensures header background respects the border radius
      child: Container(
        width: 450, // Ideal width matching your UI
        // Material is added here so the inner Container handles background clicks/shadows properly
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        clipBehavior: Clip.antiAlias, // Clip the inner container contents cleanly
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
              color: const Color(0xff333333), // Dark charcoal header background
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // --- CONTENT BODY ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end, // Aligns button to the right
                children: [
                  // Dynamically loops and creates text fields based on your hints list
                  ...List.generate(fieldHints.length, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == fieldHints.length - 1 ? 24.0 : 16.0),
                      key: ValueKey(index),
                      child: TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          hintText: fieldHints[index],
                          hintStyle: const TextStyle(color: Color(0xffcccccc)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xfff0f0f0), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Color(0xff146333), width: 1.5),
                          ),
                        ),
                      ),
                    );
                  }),

                  // --- ACTION BUTTON ---
                  ElevatedButton(
                    onPressed: onAddPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff146333), // Dark Forest Green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 1,
                    ),
                    child: buttonText
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}