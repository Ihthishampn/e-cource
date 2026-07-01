import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/general/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onEnableChanged;

  const LessonCard({
    super.key,
    required this.lesson,
    this.onEdit,
    this.onDelete,
    this.onEnableChanged,
  });

  @override
  Widget build(BuildContext context) {
    final video = lesson.videos.isNotEmpty ? lesson.videos.first : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 100,
              height: 70,
              color: Colors.grey.shade200,
              child: video?.thumbnailUrl.isNotEmpty == true &&
                      video!.thumbnailUrl != "demo"
                  ? Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.play_circle_fill,
                      size: 36,
                      color: Colors.grey,
                    ),
            ),
          ),

          const SizedBox(width: 16),

          /// Lesson Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.lessonTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                if (lesson.aboutLesson.isNotEmpty)
                  Text(
                    lesson.aboutLesson,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${video?.duration ?? 0} Minutes",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    "Preview",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Transform.scale(
                    scale: .7,
                    child: Switch(
                      value: video?.isPreview ?? false,
                      onChanged: onEnableChanged,
                      activeColor: Colors.white,
                      activeTrackColor: Colors.green,
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 14),
                  InkWell(
                    onTap: onEdit,
                    child: const Icon(
                      Icons.edit_note_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}