import 'package:e_cource/feature/cource/presentation/provider/live_provider.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WebhookLogsDialog extends StatefulWidget {
  const WebhookLogsDialog({super.key});

  @override
  State<WebhookLogsDialog> createState() => _WebhookLogsDialogState();
}

class _WebhookLogsDialogState extends State<WebhookLogsDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveProvider>().fetchWebhookLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: size.width * 0.55 > 650 ? size.width * 0.55 : 650,
        height: size.height * 0.7 > 500 ? size.height * 0.7 : 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            DialogHeader(
              title: "Zoom Webhook Logs",
              onClose: () => Navigator.pop(context),
            ),
            Expanded(
              child: Consumer<LiveProvider>(
                builder: (context, provider, _) {
                  if (provider.logsState == AppState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.logsState == AppState.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                          const SizedBox(height: 12),
                          const Text('Failed to load webhook logs'),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => provider.fetchWebhookLogs(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.webhookLogs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No webhook logs recorded yet.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Latest Webhook Activities (Auto Updates on Refresh)",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 12),
                            ),
                            TextButton.icon(
                              onPressed: () => provider.fetchWebhookLogs(),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text("Refresh Logs"),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: provider.webhookLogs.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final logItem = provider.webhookLogs[index];
                            final type = logItem['type'] as String;
                            final message = logItem['message'] as String;
                            final event = logItem['event'] as String;
                            final zoomMeetingId = logItem['zoomMeetingId'] as String;
                            final timestamp = logItem['timestamp'] as DateTime;

                            Color iconColor;
                            IconData iconData;
                            if (type == 'success') {
                              iconColor = Colors.green;
                              iconData = Icons.check_circle_outline;
                            } else if (type == 'warning') {
                              iconColor = Colors.amber;
                              iconData = Icons.warning_amber_outlined;
                            } else {
                              iconColor = Colors.redAccent;
                              iconData = Icons.error_outline;
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(iconData, color: iconColor, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              message,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            Text(
                                              DateFormat('hh:mm:ss a').format(timestamp),
                                              style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        if (event.isNotEmpty)
                                          Text(
                                            'Event: $event',
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        if (zoomMeetingId.isNotEmpty)
                                          Text(
                                            'Zoom Meeting ID: $zoomMeetingId',
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                          ),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(timestamp),
                                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
}
