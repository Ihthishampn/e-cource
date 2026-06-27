import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LiveSettingsScreen extends StatelessWidget {
  const LiveSettingsScreen({super.key});

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
                "Zoom Accounts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
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

          // List of Accounts
          Expanded(
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final accounts = [
                  {
                    'name': 'code2 live',
                    'id': '8755047271',
                    'start':
                        'https://us-central1-code-7-241f2.cloudfunctions.net/zoomWebhook/meetingStart/CVbT4ewSV... ',
                    'end':
                        'https://us-central1-code-7-241f2.cloudfunctions.net/zoomWebhook/meetingEnd/CVbT4ewSV... ',
                  },
                  {
                    'name': 'code zoom account 1',
                    'id': '8755047271',
                    'start':
                        'https://us-central1-code-7-241f2.cloudfunctions.net/zoomWebhook/meetingStart/ISvTtOs...',
                    'end':
                        'https://us-central1-code-7-241f2.cloudfunctions.net/zoomWebhook/meetingEnd/ISvTtOs...',
                  },
                  {
                    'name': 'code 7',
                    'id': '2776911247',
                    'start':
                        'https://us-central1-code-7-241f2.cloudfunctions.net/zoomWebhook/meetingStart/ulkiqNMV...',
                    'end':
                        'https://us-central1-code-7-241f2.cloudfunctions.net/zoomWebhook/meetingEnd/ulkiqNMV...',
                  },
                ];

                return ZoomAccountCard(
                  accountName: accounts[index]['name']!,
                  meetingId: accounts[index]['id']!,
                  startWebhook: accounts[index]['start']!,
                  endWebhook: accounts[index]['end']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
   
class ZoomAccountCard extends StatelessWidget {
  final String accountName;
  final String meetingId;
  final String startWebhook;
  final String endWebhook;

  const ZoomAccountCard({
    super.key,
    required this.accountName,
    required this.meetingId,
    required this.startWebhook,
    required this.endWebhook,
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
                  accountName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF444444),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Meeting Id : $meetingId',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildWebhookRow('Meeting Start Webhook :', startWebhook),
                const SizedBox(height: 10),
                _buildWebhookRow('Meeting End Webhook :', endWebhook),
              ],
            ),
          ),

          // Action Icons
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.grey,
                ),
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
          onTap: () {},
          child: const Icon(Icons.copy, size: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
