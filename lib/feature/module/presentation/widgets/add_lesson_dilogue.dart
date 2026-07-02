import 'dart:async';
import 'dart:developer';

import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/feature/lesson/presentation/provider/lesson_provider.dart';
import 'package:e_cource/feature/module/presentation/provider/add_lesson_dialog_provider.dart';
import 'package:e_cource/feature/module/presentation/widgets/choose_vedio_button.dart';
import 'package:e_cource/feature/module/presentation/widgets/lesson_text_field.dart';
import 'package:e_cource/feature/module/presentation/widgets/uplod_field.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';

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

  Future<void> _submitLesson(
    LessonProvider provider,
    AddLessonDialogProvider dialogProvider,
  ) async {
    log('[AddLessonDialog] _submitLesson: start');
    final title = titleController.text.trim();
    final minutesText = minuteController.text.trim();
    final about = aboutController.text.trim();

    if (title.isEmpty) {
      showToast(msg: 'Lesson title cannot be empty');
      return;
    }

    if (minutesText.isEmpty) {
      showToast(msg: 'Lesson duration is required');
      return;
    }

    int duration = 0;
    if (minutesText.contains(':')) {
      final parts = minutesText.split(':').map((e) => int.tryParse(e) ?? 0).toList();
      if (parts.length == 3) {
        duration = parts[0] * 3600 + parts[1] * 60 + parts[2];
      } else if (parts.length == 2) {
        duration = parts[0] * 60 + parts[1];
      }
    } else {
      duration = int.tryParse(minutesText) ?? 0;
      // If it's just a number, we assume it's minutes (for backwards compatibility if they typed it manually)
      duration = duration * 60;
    }

    if (duration <= 0) {
      showToast(msg: 'Please enter a valid lesson duration (e.g. 10:00)');
      return;
    }

    if (about.isEmpty) {
      showToast(msg: 'Please enter lesson details');
      return;
    }

    if (dialogProvider.pickedVideoBytes == null || dialogProvider.selectedVideoFileName == null) {
      log('[AddLessonDialog] _submitLesson: missing video');
      showToast(msg: 'Please select a valid MP4 video file.');
      return;
    }

    final model = LessonModel(
      lessonId: '',
      moduleId: widget.moduleId,
      courseId: widget.courseId,
      lessonTitle: title,
      aboutLesson: about,
      createdAt: DateTime.now(),
      videos: [
        LessonVideoModel(
          videoId: '',
          title: title,
          videoUrl: '',
          thumbnailUrl: '',
          isPreview: false,
          duration: duration,
        ),
      ],
    );

    log('[AddLessonDialog] _submitLesson: calling provider.handleAddLesson');
    await provider.handleAddLesson(
      model,
      videoBytes: dialogProvider.pickedVideoBytes,
      fileName: dialogProvider.selectedVideoFileName,
    );

    log(
      '[AddLessonDialog] _submitLesson: provider returned state=${provider.addLessonState}',
    );

    if (!mounted) return;

    if (provider.addLessonState == AppState.success) {
      titleController.clear();
      minuteController.clear();
      aboutController.clear();
      dialogProvider.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddLessonDialogProvider(),
      child: Dialog(
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
                title: 'Add Lesson',
                onClose: () => Navigator.pop(context),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Consumer<AddLessonDialogProvider>(
                      builder: (context, dialogProvider, _) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 110,
                              child: Text(
                                'Add Video',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ChooseVideoButton(
                              onTap: () => dialogProvider.pickVideo(minuteController),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                dialogProvider.selectedVideoFileName ?? 'No video selected',
                                style: TextStyle(
                                  color: dialogProvider.selectedVideoFileName != null
                                      ? Colors.black87
                                      : Colors.grey,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 22),
                  LessonTextField(
                    controller: titleController,
                    hint: 'Lesson Title*',
                  ),
                  const SizedBox(height: 16),
                  LessonTextField(
                    controller: minuteController,
                    hint: 'Lesson Minute*',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  UploadField(hint: 'Add Study Material (PDF)', onTap: () {}),
                  const SizedBox(height: 16),
                  LessonTextField(
                    controller: aboutController,
                    hint: 'About Lesson',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),
                  Consumer2<LessonProvider, AddLessonDialogProvider>(
                    builder: (context, provider, dialogProvider, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (dialogProvider.selectedVideoError != null) ...[
                            Text(
                              dialogProvider.selectedVideoError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (provider.addLessonState == AppState.loading) ...[
                            LinearProgressIndicator(
                              value: provider.uploadProgress,
                              minHeight: 6,
                              color: AppColors.primaryColor,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Uploading video: ${(provider.uploadProgress * 100).toStringAsFixed(0)}%',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
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
                                    : () => _submitLesson(provider, dialogProvider),
                                child:
                                    provider.addLessonState == AppState.loading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Add'),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     ) );
  }
}
