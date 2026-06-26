import 'package:e_cource/feature/settings/presentation/widgets/custom_label_text_field.dart';
import 'package:e_cource/feature/settings/presentation/widgets/custom_small_button.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final TextEditingController privacyHeaderController;
  final TextEditingController privacyDescriptionController;

  const PrivacyPolicyScreen({
    super.key,
    required this.privacyHeaderController,
    required this.privacyDescriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Privacy Policy",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomLabelTextField(
                  name: 'Header',
                  controller: privacyHeaderController,
                  isRequired: true,
                ),

                const SizedBox(height: 24),

                CustomLabelTextField(
                  name: 'Description',
                  controller: privacyDescriptionController,
                  isRequired: true,
                  minLines: 8,
                  maxLines: 8,
                  horizontalPadding: 16,
                  verticalPadding: 16,
                ),
                const SizedBox(height: 16),

                CustomSmallButtonSettings(ontap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
