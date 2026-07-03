import 'package:e_cource/feature/exam/presentation/provider/add_exam_firebase_provider.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/core/services/go_route/route_names.dart';
import 'package:e_cource/general/widgets/button_with_icon.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CourseExamWidget extends StatefulWidget {
  final String courseId;

  const CourseExamWidget({super.key, required this.courseId});

  @override
  State<CourseExamWidget> createState() => _CourseExamWidgetState();
}

class _CourseExamWidgetState extends State<CourseExamWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddExamFirebaseProvider>().handleFetchExams(
            courseId: widget.courseId,
            moduleId: '',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Final Examination',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ButtonWithIcon(
                name: 'Add a final exam',
                icon: Icons.add,
                ontap: () {
                  context.push(
                    RouteNames.addFinalExam,
                    extra: <String, String>{
                      'courseId': widget.courseId,
                      'moduleId': '',
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Exam list from provider ───────────────────────────────────────
          Consumer<AddExamFirebaseProvider>(
            builder: (context, provider, _) {
              if (provider.fetchExamState == AppState.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (provider.examList.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Text(
                      'No final exams created yet for this course.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.examList.length,
                itemBuilder: (context, index) {
                  final exam = provider.examList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ExamCard(
                      title: 'Final Examination',
                      minutes: exam.duration,
                      totalMarks: exam.totalMarks,
                      passMarks: exam.passMarks,
                      isEnabled: exam.isEnabled,
                      onDelete: () => _confirmDelete(context, exam.examId),
                      onEdit: () {
                        // Edit placeholder or edit screen if needed
                      },
                      onToggle: (val) {
                        provider.handleToggleExamStatus(
                          examId: exam.examId,
                          isEnabled: val,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String examId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Exam'),
        content: const Text('Are you sure you want to delete this final exam?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AddExamFirebaseProvider>().handleDeleteExam(examId: examId).then((_) {
                toastification.show(
                  type: ToastificationType.success,
                  title: const Text('Exam deleted successfully'),
                );
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Exam card (mirrors the design in the screenshot) ────────────────────────
class _ExamCard extends StatelessWidget {
  final String title;
  final int minutes;
  final int totalMarks;
  final int passMarks;
  final bool isEnabled;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<bool> onToggle;

  const _ExamCard({
    required this.title,
    required this.minutes,
    required this.totalMarks,
    required this.passMarks,
    required this.isEnabled,
    required this.onDelete,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          _infoRow(Icons.access_time_outlined, '$minutes Mins'),
          const SizedBox(height: 4),
          _infoRow(Icons.check_circle_outline, 'Total Marks : $totalMarks'),
          const SizedBox(height: 4),
          _infoRow(Icons.person_outline, 'Pass Marks : $passMarks'),

          const SizedBox(height: 12),

          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 22),
                tooltip: 'Delete',
              ),
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined,
                    color: AppColors.primaryColor, size: 22),
                tooltip: 'Edit',
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Enable',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: onToggle,
                    activeColor: Colors.green,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      );
}