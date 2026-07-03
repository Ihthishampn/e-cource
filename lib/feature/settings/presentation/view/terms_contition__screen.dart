import 'package:e_cource/feature/settings/presentation/widgets/custom_label_text_field.dart';
import 'package:e_cource/feature/settings/presentation/widgets/custom_small_button.dart';
import 'package:e_cource/feature/settings/presentation/provider/settings_provider.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() => _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  late final TextEditingController headerController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    headerController = TextEditingController();
    descriptionController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SettingsProvider>();
      await provider.getTermsAndCondition();
      
      if (provider.termsGetState == AppState.success) {
        headerController.text = provider.termsData["terms_header"
] ?? "";
        descriptionController.text = provider.termsData["terms_description"] ?? "";
      }
    });
  }

  @override
  void dispose() {
    headerController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          if (provider.termsGetState == AppState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.termsGetState == AppState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to load Terms & Conditions"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.getTermsAndCondition(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return Column(
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
                      hintText: "Add terms header",
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
                      hintText: "Add terms description",
                    ),

                    const SizedBox(height: 16),

                    provider.termsUpdateState == AppState.loading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomSmallButtonSettings(
                            ontap: () async {
                              await provider.updateTermsAndCondition(
                                header: headerController.text.trim(),
                                description: descriptionController.text.trim(),
                              );

                              if (context.mounted) {
                                if (provider.termsUpdateState == AppState.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Terms updated successfully!")),
                                  );
                                } else if (provider.termsUpdateState == AppState.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to update Terms")),
                                  );
                                }
                              }
                            },
                          ),
                  ],
                ),
              ),
              const Gap(12),
            ],
          );
        },
      ),
    );
  }
}