import 'package:e_cource/feature/settings/presentation/widgets/custom_label_text_field.dart';
import 'package:e_cource/feature/settings/presentation/widgets/custom_small_button.dart';
import 'package:e_cource/feature/settings/presentation/provider/settings_provider.dart'; // Verify path
import 'package:e_cource/general/enums/app_state.dart'; // Verify path
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final TextEditingController privacyHeaderController;
  late final TextEditingController privacyDescriptionController;

  @override
  void initState() {
    super.initState();
    privacyHeaderController = TextEditingController();
    privacyDescriptionController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SettingsProvider>();
      await provider.getPrivacyPolicy();
      
      if (provider.privacyGetState == AppState.success) {
        privacyHeaderController.text = provider.privacyData["privacy_header"] ?? "";
        privacyDescriptionController.text = provider.privacyData["privacy_description"] ?? "";
      }
    });
  }

  @override
  void dispose() {
    privacyHeaderController.dispose();
    privacyDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          if (provider.privacyGetState == AppState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.privacyGetState == AppState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to load Privacy Policy"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.getPrivacyPolicy(),
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
                      hintText: "Add privacy header",
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
                      hintText: "Add privacy description",
                    ),
                    const SizedBox(height: 16),

                    provider.privacyUpdateState == AppState.loading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomSmallButtonSettings(
                            ontap: () async {
                              await provider.updatePrivacyPolicy(
                                header: privacyHeaderController.text.trim(),
                                description: privacyDescriptionController.text.trim(),
                              );

                              if (context.mounted) {
                                if (provider.privacyUpdateState == AppState.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Privacy Policy updated successfully!")),
                                  );
                                } else if (provider.privacyUpdateState == AppState.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to update Privacy Policy")),
                                  );
                                }
                              }
                            },
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}