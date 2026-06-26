import 'package:e_cource/feature/settings/presentation/widgets/custom_label_text_field.dart';
import 'package:e_cource/feature/settings/presentation/widgets/custom_small_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpAndSupportScreen extends StatelessWidget {
  final TextEditingController helpWpNUmberController;
  final TextEditingController helpEmailController;
  final TextEditingController helpContactController;
  const HelpAndSupportScreen({
    super.key,
    required this.helpWpNUmberController,
    required this.helpEmailController,
    required this.helpContactController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text(
              "Help And Support",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Add Details To Connect Users",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 85, 84, 84),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLabelTextField(
                    name: 'WhatsApp Number',
                    controller: helpWpNUmberController,
                    isRequired: false,
                  ),

                  const SizedBox(height: 24),

                  CustomLabelTextField(
                    name: 'E-Mail',
                    controller: helpEmailController,
                    isRequired: true,
                  ),
                  const SizedBox(height: 24),

                  CustomLabelTextField(
                    name: 'Contact Number',
                    controller: helpContactController,
                    isRequired: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            CustomSmallButtonSettings(ontap: () {}),
            const Gap(12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update & Save',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    
  }
}
