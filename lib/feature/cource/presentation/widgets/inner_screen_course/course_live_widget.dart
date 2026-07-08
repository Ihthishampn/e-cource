import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/data/model/live_model.dart';
import 'package:e_cource/feature/cource/presentation/provider/live_provider.dart';
import 'package:e_cource/feature/cource/presentation/widgets/inner_screen_course/add_live_dialog.dart';
import 'package:e_cource/feature/cource/presentation/widgets/inner_screen_course/webhook_logs_dialog.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CourseLiveWidget extends StatefulWidget {
  final CourseModel course;

  const CourseLiveWidget({super.key, required this.course});

  @override
  State<CourseLiveWidget> createState() => _CourseLiveWidgetState();
}

class _CourseLiveWidgetState extends State<CourseLiveWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveProvider>().fetchLivesForCourse(widget.course.id);
    });
  }

  void _showAddLiveDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: context.read<LiveProvider>(),
        child: AddLiveDialog(course: widget.course),
      ),
    );
  }

  void _showWebhookLogsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: context.read<LiveProvider>(),
        child: const WebhookLogsDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Live Sessions",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _showWebhookLogsDialog,
                  icon: const Icon(Icons.history_edu, color: Colors.grey, size: 20),
                  label: const Text(
                    "View Logs",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _showAddLiveDialog,
                  icon: const Icon(Icons.video_call, color: Colors.white, size: 20),
                  label: const Text(
                    "Go Live",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Live sessions list
        Expanded(
          child: Consumer<LiveProvider>(
            builder: (context, provider, _) {
              if (provider.fetchState == AppState.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.fetchState == AppState.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text(provider.errorMessage ?? 'Failed to load live meetings'),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => provider.fetchLivesForCourse(widget.course.id),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (provider.lives.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.live_tv_outlined, size: 56, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No live sessions scheduled yet.',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap "Go Live" to schedule and start a Zoom meeting.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: provider.lives.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final live = provider.lives[index];
                  return _LiveSessionCard(
                    live: live,
                    onStart: () => provider.startMeeting(live),
                    onEnd: () => _confirmEndMeeting(context, provider, live),
                    onDelete: () => _confirmDeleteMeeting(context, provider, live),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmEndMeeting(BuildContext context, LiveProvider provider, LiveModel live) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End Meeting'),
        content: Text('Are you sure you want to end "${live.title}"? This will mark it as completed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              provider.endMeeting(live.id);
            },
            child: const Text('End Meeting', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMeeting(BuildContext context, LiveProvider provider, LiveModel live) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Scheduled Meeting'),
        content: Text('Are you sure you want to delete "${live.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              provider.deleteMeeting(live.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class _LiveSessionCard extends StatelessWidget {
  final LiveModel live;
  final VoidCallback onStart;
  final VoidCallback onEnd;
  final VoidCallback onDelete;

  const _LiveSessionCard({
    required this.live,
    required this.onStart,
    required this.onEnd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOnLive = live.status == 'onlive' || live.status == 'onLive';
    final isCompleted = live.status == 'completed';

    Color statusColor;
    String statusText;
    if (isOnLive) {
      statusColor = Colors.redAccent;
      statusText = 'ON LIVE';
    } else if (isCompleted) {
      statusColor = Colors.grey;
      statusText = 'COMPLETED';
    } else {
      statusColor = AppColors.buttonBlue;
      statusText = 'SCHEDULED';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Status Indicator & Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnLive
                  ? Icons.videocam
                  : isCompleted
                      ? Icons.check_circle_outline
                      : Icons.calendar_today_outlined,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Session Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isOnLive)
                      _buildPulseIndicator(),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  live.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, yyyy - hh:mm a').format(live.scheduledAt),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Account: ${live.zoomAccountName}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.vpn_key_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'ID: ${live.meetingId}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Actions Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isCompleted) ...[
                ElevatedButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.launch, size: 14, color: Colors.white),
                  label: const Text(
                    'Start Meeting',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: onEnd,
                  icon: const Icon(Icons.stop, size: 14, color: Colors.redAccent),
                  label: const Text(
                    'End Meeting',
                    style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ] else
                const Text(
                  'Finished',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              const SizedBox(height: 4),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                tooltip: 'Delete Schedule',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPulseIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
