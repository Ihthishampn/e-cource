import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/feature/lesson/presentation/provider/lesson_provider.dart';
import 'package:e_cource/feature/module/presentation/widgets/choose_vedio_button.dart';
import 'package:e_cource/feature/module/presentation/widgets/lesson_text_field.dart';
import 'package:e_cource/feature/module/presentation/widgets/uplod_field.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLessonDialog extends StatefulWidget {
  final String moduleId;
  final String courseId;
  const AddLessonDialog({
    super.key,
    required this.moduleId,
    required this.courseId,
  });

  @override
  State<AddLessonDialog> createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<AddLessonDialog> {
  final titleController = TextEditingController();
  final minuteController = TextEditingController();
  final aboutController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    minuteController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              title: "Add Lesson",
              onClose: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 110,
                        child: Text(
                          "Add Video",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ChooseVideoButton(onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 22),
                  LessonTextField(
                    controller: titleController,
                    hint: "Lesson Title*",
                  ),
                  const SizedBox(height: 16),
                  LessonTextField(
                    controller: minuteController,
                    hint: "Lesson Minute*",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  UploadField(hint: "Add Study Material (PDF)", onTap: () {}),
                  const SizedBox(height: 16),
                  LessonTextField(
                    controller: aboutController,
                    hint: "About Lesson",
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Consumer<LessonProvider>(
                      builder: (context, provider, _) {
                        return SizedBox(
                          width: 100,
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff005BAA),
                              foregroundColor: Colors.white,
                            ),
                            onPressed:
                                provider.addLessonState == AppState.loading
                                ? null
                                : () async {
                                    if (titleController.text.trim().isEmpty) {
                                      showToast(msg: "title cante be empty");
                                      return;
                                    }

                                    final model = LessonModel(
                                      lessonId: '',
                                      moduleId: widget.moduleId,
                                      courseId: widget.courseId,
                                      lessonTitle: titleController.text.trim(),
                                      aboutLesson: aboutController.text.trim(),
                                      createdAt: DateTime.now(),
                                      videos: [
                                        LessonVideoModel(
                                          videoId: 'demo',
                                          title: titleController.text.trim(),
                                          videoUrl: "demo",
                                          thumbnailUrl: 'demo',

                                          isPreview: false,
                                          duration:
                                              int.tryParse(
                                                minuteController.text,
                                              ) ??
                                              0,
                                        ),
                                      ],
                                    );

                                    await provider.handleAddLesson(model);

                                    if (!mounted) return;

                                    if (provider.addLessonState ==
                                        AppState.success) {
                                      Navigator.pop(context);
                                    }
                                  },
                            child: provider.addLessonState == AppState.loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Add"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
