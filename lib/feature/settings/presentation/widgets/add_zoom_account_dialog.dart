import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:e_cource/feature/settings/presentation/provider/live_settings_provider.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddZoomAccountDialog extends StatefulWidget {
  const AddZoomAccountDialog({super.key});

  @override
  State<AddZoomAccountDialog> createState() => _AddZoomAccountDialogState();
}

class _AddZoomAccountDialogState extends State<AddZoomAccountDialog> {
  final _formKey = GlobalKey<FormState>();

  final _accountNameCtrl = TextEditingController();
  final _meetingIdCtrl = TextEditingController();
  final _meetingPasscodeCtrl = TextEditingController();
  final _meetingClientIdCtrl = TextEditingController();
  final _meetingClientSecretCtrl = TextEditingController();
  final _accountIdCtrl = TextEditingController();
  final _clientIdCtrl = TextEditingController();
  final _clientSecretCtrl = TextEditingController();
  final _webhookSecretCtrl = TextEditingController();
  final _liveLinkCtrl = TextEditingController();

  @override
  void dispose() {
    _accountNameCtrl.dispose();
    _meetingIdCtrl.dispose();
    _meetingPasscodeCtrl.dispose();
    _meetingClientIdCtrl.dispose();
    _meetingClientSecretCtrl.dispose();
    _accountIdCtrl.dispose();
    _clientIdCtrl.dispose();
    _clientSecretCtrl.dispose();
    _webhookSecretCtrl.dispose();
    _liveLinkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            DialogHeader(
              title: 'Add Zoom Account',
              onClose: () => Navigator.pop(context),
            ),

            // Scrollable form body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _field('Account Name', _accountNameCtrl,
                          'Enter Account Name'),
                      _field('Meeting ID', _meetingIdCtrl, 'Enter Meeting ID'),
                      _field('Meeting Passcode', _meetingPasscodeCtrl,
                          'Enter Meeting Passcode'),

                      _sectionTitle('Meeting SDK Credentials'),
                      _field('Meeting Client ID', _meetingClientIdCtrl,
                          'Enter Meeting Client ID'),
                      _field('Meeting Client Secret', _meetingClientSecretCtrl,
                          'Enter Meeting Client Secret'),

                      _sectionTitle('Server OAuth Credentials'),
                      _field('Account ID', _accountIdCtrl, 'Enter Account ID'),
                      _field('Client ID', _clientIdCtrl, 'Enter Client ID'),
                      _field('Client Secret', _clientSecretCtrl,
                          'Enter Client Secret'),

                      _sectionTitle('Webhook Credentials'),
                      _field('Webhook Secret', _webhookSecretCtrl,
                          'Enter Webhook Secret'),
                      _field('Live Link', _liveLinkCtrl, 'Enter Live Link',
                          required: false),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),

            // Footer buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Consumer<LiveSettingsProvider>(
                builder: (context, provider, _) {
                  final isLoading = provider.addState == AppState.loading;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: isLoading ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final account = ZoomAccountModel(
      id: '',
      accountName: _accountNameCtrl.text.trim(),
      meetingId: _meetingIdCtrl.text.trim(),
      meetingPasscode: _meetingPasscodeCtrl.text.trim(),
      meetingClientId: _meetingClientIdCtrl.text.trim(),
      meetingClientSecret: _meetingClientSecretCtrl.text.trim(),
      accountId: _accountIdCtrl.text.trim(),
      clientId: _clientIdCtrl.text.trim(),
      clientSecret: _clientSecretCtrl.text.trim(),
      webhookSecret: _webhookSecretCtrl.text.trim(),
      liveLink: _liveLinkCtrl.text.trim(),
    );

    final provider =
        context.read<LiveSettingsProvider>();
    final success = await provider.addZoomAccount(account);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          color: Color(0xFF222222),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String hint, {
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            validator: required
                ? (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null
                : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
