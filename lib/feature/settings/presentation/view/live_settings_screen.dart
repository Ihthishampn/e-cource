import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:e_cource/feature/settings/presentation/provider/live_settings_provider.dart';
import 'package:e_cource/feature/settings/presentation/widgets/add_zoom_account_dialog.dart';
import 'package:e_cource/general/core/di/injection/injection_config.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LiveSettingsScreen extends StatelessWidget {
  const LiveSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<LiveSettingsProvider>()..fetchZoomAccounts(),
      child: const _LiveSettingsBody(),
    );
  }
}

class _LiveSettingsBody extends StatelessWidget {
  const _LiveSettingsBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Zoom Accounts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              ElevatedButton(
                onPressed: () => _showAddDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Add Account',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // List
          Expanded(
            child: Consumer<LiveSettingsProvider>(
              builder: (context, provider, _) {
                // Loading
                if (provider.fetchState == AppState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Error
                if (provider.fetchState == AppState.error) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        const Text(
                          'Failed to load Zoom accounts.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () =>
                              provider.fetchZoomAccounts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty
                if (provider.zoomAccounts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.video_call_outlined,
                            size: 56, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No Zoom accounts yet.',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tap "Add Account" to get started.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                // Data
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: provider.zoomAccounts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final account = provider.zoomAccounts[index];
                    return ZoomAccountCard(
                      account: account,
                      onDelete: () => _confirmDelete(context, provider, account),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<LiveSettingsProvider>(),
        child: const AddZoomAccountDialog(),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    LiveSettingsProvider provider,
    ZoomAccountModel account,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
            'Delete "${account.accountName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteZoomAccount(account.id);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class ZoomAccountCard extends StatelessWidget {
  final ZoomAccountModel account;
  final VoidCallback onDelete;

  const ZoomAccountCard({
    super.key,
    required this.account,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.accountName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF444444),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Meeting Id : ${account.meetingId}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildWebhookRow(
                    'Meeting Start Webhook :', account.startWebhookUrl),
                const SizedBox(height: 10),
                _buildWebhookRow(
                    'Meeting End Webhook :', account.endWebhookUrl),
                const SizedBox(height: 10),
                _buildWebhookRow(
                    'Recording Webhook :', account.recordingWebhookUrl),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: Colors.grey),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWebhookRow(String label, String url) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF444444),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            url,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: url));
          },
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.copy, size: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
