import 'package:e_cource/feature/lesson/presentation/provider/lesson_provider.dart';
import 'package:e_cource/feature/module/data/model/module_model.dart';
import 'package:e_cource/feature/module/presentation/widgets/choose_lesson_option_dilogue.dart';
import 'package:e_cource/feature/module/presentation/widgets/lesson_card.dart';
import 'package:e_cource/general/core/theme/app_text_styles.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ModuleCard extends StatelessWidget {
  final ModuleModel module;

  const ModuleCard({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E1E1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        module.moduleName,
                        style: AppTextStyles.heading3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit_calendar_outlined,
                            color: Colors.blue,
                            size: 21,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Lessons
         Consumer<LessonProvider>(
  builder: (context, provider, _) {
    final state = provider.getLessonState;

    final lessons = provider.lessonList
        .where((lesson) => lesson.moduleId == module.moduleId)
        .toList();

    if (state == AppState.loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: List.generate(4, (index) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 32) / 2,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    }

    if (state == AppState.error) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "Failed to load lessons",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    if (lessons.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Text(
          "No lessons added yet",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 10) / 2;

        return Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: lessons.map((lesson) {
              return SizedBox(
                width: itemWidth,
                child: LessonCard(
                  lesson: lesson,
                  onDelete: () {},
                  onEdit: () {},
                  onEnableChanged: (value) {
  final video = lesson.videos.isNotEmpty ? lesson.videos.first : null;

  if (video == null) return;

  context.read<LessonProvider>().handleUpdatePreview(
    val: value,
    lessonId: lesson.lessonId,
    videoId: video.videoId,
  );
},
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  },
),

            const SizedBox(height: 12),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  name: "Add Lesson",
                  color: const Color(0xff030B1D),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ChooseLessonOptionDialog(
                        courseId: module.courseId,
                        moduleId: module.moduleId,
                      ),
                    );
                  },
                ),
                const Gap(6),
                CustomElevatedButton(
                  name: "Add Exam",
                  color: const Color(0xff115C99),
                  onTap: () {},
                ),
                const Gap(6),
                CustomElevatedButton(
                  name: "Add Assignment",
                  color: const Color(0xff6C0985),
                  onTap: () {},
                ),
              ],
            ),

            const Gap(10),
          ],
        ),
      ),
    );
  }
}
