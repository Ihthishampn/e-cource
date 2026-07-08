import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/presentation/provider/live_provider.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_section.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_text_field.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AddLiveDialog extends StatefulWidget {
  final CourseModel course;

  const AddLiveDialog({super.key, required this.course});

  @override
  State<AddLiveDialog> createState() => _AddLiveDialogState();
}

class _AddLiveDialogState extends State<AddLiveDialog> {
  final _topicController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  final _passcodeController = TextEditingController();

  ZoomAccountModel? _selectedAccount;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveProvider>().fetchZoomAccounts();
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    _durationController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    final topic = _topicController.text.trim();
    final durationStr = _durationController.text.trim();
    final passcode = _passcodeController.text.trim();

    if (topic.isEmpty) {
      _showToast('Please enter live class topic', ToastificationType.warning);
      return;
    }

    if (_selectedAccount == null) {
      _showToast('Please select a Zoom account', ToastificationType.warning);
      return;
    }

    if (_selectedDateTime == null) {
      _showToast('Please pick a scheduled date & time', ToastificationType.warning);
      return;
    }

    final duration = int.tryParse(durationStr) ?? 30;

    final success = await context.read<LiveProvider>().scheduleLive(
          courseId: widget.course.id,
          courseName: widget.course.name,
          title: topic,
          zoomAccount: _selectedAccount!,
          scheduledAt: _selectedDateTime!,
          duration: duration,
          passcode: passcode,
        );

    if (success) {
      _showToast('Live session scheduled successfully!', ToastificationType.success);
      if (mounted) Navigator.pop(context);
    } else {
      final error = context.read<LiveProvider>().errorMessage ?? 'Failed to schedule live';
      _showToast(error, ToastificationType.error);
    }
  }

  void _showToast(String msg, ToastificationType type) {
    toastification.show(
      title: Text(msg),
      type: type,
      autoCloseDuration: const Duration(seconds: 4),
      style: ToastificationStyle.flatColored,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: size.width * 0.45 > 500 ? size.width * 0.45 : 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              title: "Schedule Zoom Live",
              onClose: () => Navigator.pop(context),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Topic
                    DialogSectionRow(
                      label: "Topic/Title",
                      required: true,
                      child: DialogTextField(
                        controller: _topicController,
                        hint: "Enter topic of the live class",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Zoom Account Selection
                    DialogSectionRow(
                      label: "Zoom Account",
                      required: true,
                      child: Consumer<LiveProvider>(
                        builder: (context, provider, _) {
                          if (provider.zoomAccountsState == AppState.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (provider.zoomAccounts.isEmpty) {
                            return const Text(
                              'No Zoom Accounts. Please add one in settings first.',
                              style: TextStyle(color: Colors.redAccent, fontSize: 13),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<ZoomAccountModel>(
                                isExpanded: true,
                                value: _selectedAccount,
                                hint: const Text("Select Zoom Account"),
                                items: provider.zoomAccounts.map((account) {
                                  return DropdownMenuItem<ZoomAccountModel>(
                                    value: account,
                                    child: Text(account.accountName),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedAccount = val;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date & Time
                    DialogSectionRow(
                      label: "Scheduled At",
                      required: true,
                      child: InkWell(
                        onTap: _pickDateTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDateTime == null
                                    ? "Select Date & Time"
                                    : DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime!),
                                style: TextStyle(
                                  color: _selectedDateTime == null ? Colors.grey.shade500 : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Duration
                    DialogSectionRow(
                      label: "Duration (min)",
                      required: true,
                      child: DialogTextField(
                        controller: _durationController,
                        hint: "Duration in minutes (e.g. 30, 60)",
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Optional Passcode
                    DialogSectionRow(
                      label: "Passcode",
                      hint: "Optional passcode for the meeting",
                      child: DialogTextField(
                        controller: _passcodeController,
                        hint: "Enter meeting passcode",
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Action buttons
                    Consumer<LiveProvider>(
                      builder: (context, provider, _) {
                        final isLoading = provider.createLiveState == AppState.loading;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isLoading ? null : () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      "Schedule Meeting",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
