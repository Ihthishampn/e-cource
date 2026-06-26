import 'package:e_cource/feature/settings/presentation/widgets/custom_label_text_field.dart';
import 'package:e_cource/feature/settings/presentation/widgets/custom_small_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TermsAndContition extends StatelessWidget {
  final TextEditingController headerController;
  final TextEditingController descriptionController;
  const TermsAndContition({
    super.key,
    required this.headerController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Terms And Condition",
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
                  controller: headerController,
                  isRequired: true,
                ),

                const SizedBox(height: 24),

                CustomLabelTextField(
                  name: 'Description',
                  controller: descriptionController,
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
