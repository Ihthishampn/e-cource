import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String lessonId;
  final String moduleId;
  final String courseId;
  final String lessonTitle;
  final String aboutLesson;
  final List<LessonVideoModel> videos;
  final DateTime createdAt;

  LessonModel({
    required this.lessonId,
    required this.moduleId,
    required this.courseId,
    required this.lessonTitle,
    required this.aboutLesson,
    required this.videos,
    required this.createdAt,
  });

  LessonModel copyWith({
    String? lessonId,
    String? moduleId,
    String? courseId,
    String? lessonTitle,
    String? aboutLesson,
    List<LessonVideoModel>? videos,
    DateTime? createdAt,
  }) {
    return LessonModel(
      lessonId: lessonId ?? this.lessonId,
      moduleId: moduleId ?? this.moduleId,
      courseId: courseId ?? this.courseId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      aboutLesson: aboutLesson ?? this.aboutLesson,
      videos: videos ?? this.videos,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory LessonModel.fromMap(Map<String, dynamic> json, String id) {
    return LessonModel(
      lessonId: id,
      moduleId: json['moduleId'],
      courseId: json['courseId'],
      lessonTitle: json['lessonName'],
      aboutLesson: json['aboutLesson'],
      videos: (json['videos'] as List<dynamic>)
          .map((e) => LessonVideoModel.fromMap(e))
          .toList(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'courseId': courseId,
      'lessonName': lessonTitle,
      'aboutLesson': aboutLesson,
      'videos': videos.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.now(),
    };
  }
}

class LessonVideoModel {
  final String videoId;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final int duration;
  final bool isPreview;

  LessonVideoModel({
    required this.videoId,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.isPreview,
  });

  LessonVideoModel copyWith({
    String? videoId,
    String? title,
    String? videoUrl,
    String? thumbnailUrl,
    int? durationInSeconds,
    bool? isPreview,
  }) {
    return LessonVideoModel(
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: durationInSeconds ?? duration,
      isPreview: isPreview ?? this.isPreview,
    );
  }

  factory LessonVideoModel.fromMap(Map<String, dynamic> json) {
    return LessonVideoModel(
      videoId: json['videoId'],
      title: json['title'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['durationInSeconds'],
      isPreview: json['isPreview'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'title': title,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'durationInSeconds': duration,
      'isPreview': isPreview,
    };
  }
}