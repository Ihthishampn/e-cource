import 'package:e_cource/feature/settings/presentation/widgets/custom_label_text_field.dart';
import 'package:e_cource/feature/settings/presentation/widgets/custom_small_button.dart';
import 'package:e_cource/feature/settings/presentation/provider/settings_provider.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  late final TextEditingController helpWpNUmberController;
  late final TextEditingController helpEmailController;
  late final TextEditingController helpContactController;

  @override
  void initState() {
    super.initState();
    helpWpNUmberController = TextEditingController();
    helpEmailController = TextEditingController();
    helpContactController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SettingsProvider>();
      await provider.getHelpAndSupport();
      
      if (provider.helpGetState == AppState.success) {
        helpWpNUmberController.text = provider.helpData["whatsAppNUmber"] ?? "";
        helpEmailController.text = provider.helpData["eMail"] ?? "";
        helpContactController.text = provider.helpData["contactNumber"] ?? "";
      }
    });
  }

  @override
  void dispose() {
    helpWpNUmberController.dispose();
    helpEmailController.dispose();
    helpContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          if (provider.helpGetState == AppState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.helpGetState == AppState.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to load Help & Support details"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.getHelpAndSupport(),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLabelTextField(
                      name: 'WhatsApp Number',
                      controller: helpWpNUmberController,
                      isRequired: false,
                      hintText: "Add WhatsApp number",
                    ),

                    const SizedBox(height: 24),

                    CustomLabelTextField(
                      name: 'E-Mail',
                      controller: helpEmailController,
                      isRequired: true,
                      hintText: "Add support email",
                    ),
                    const SizedBox(height: 24),

                    CustomLabelTextField(
                      name: 'Contact Number',
                      controller: helpContactController,
                      isRequired: true,
                      hintText: "Add contact number",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              provider.helpUpdateState == AppState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomSmallButtonSettings(
                      ontap: () async {
                        await provider.updateHelpAndSupport(
                          contactNumber: helpContactController.text.trim(),
                          eMail: helpEmailController.text.trim(),
                          whatsAppNUmber: helpWpNUmberController.text.trim(),
                        );

                        if (context.mounted) {
                          if (provider.helpUpdateState == AppState.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Help & Support updated successfully!")),
                            );
                          } else if (provider.helpUpdateState == AppState.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to update details")),
                            );
                          }
                        }
                      },
                    ),
              const Gap(12),
            ],
          );
        },
      ),
    );
  }
}