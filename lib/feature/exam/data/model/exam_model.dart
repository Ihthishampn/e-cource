import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/exam/data/model/exam_question_model.dart';

class ExamModel {
  final String examId;
  final String courseId;
  final String moduleId;
  final String moduleName;
  final int duration;
  final int totalMarks;
  final int passMarks;
  final List<String> terms;
  final List<ExamQuestionModel> questions;
  final bool hasRetry;
  final String? retryDuration;
  final bool isEnabled;
  final DateTime createdAt;

  const ExamModel({
    required this.examId,
    required this.courseId,
    required this.moduleId,
    required this.moduleName,
    required this.duration,
    required this.totalMarks,
    required this.passMarks,
    required this.terms,
    required this.questions,
    required this.hasRetry,
    this.retryDuration,
    required this.isEnabled,
    required this.createdAt,
  });

  factory ExamModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ExamModel(
      examId: documentId,
      courseId: map['courseId'] as String? ?? '',
      moduleId: map['moduleId'] as String? ?? '',
      moduleName: map['moduleName'] as String? ?? '',
      duration: map['duration'] as int? ?? 0,
      totalMarks: map['totalMarks'] as int? ?? 0,
      passMarks: map['passMarks'] as int? ?? 0,
      terms: List<String>.from(map['terms'] as List? ?? []),
      questions: (map['questions'] as List? ?? [])
          .map((q) => ExamQuestionModel.fromMap(Map<String, dynamic>.from(q as Map)))
          .toList(),
      hasRetry: map['hasRetry'] as bool? ?? false,
      retryDuration: map['retryDuration'] as String?,
      isEnabled: map['isEnabled'] as bool? ?? true,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'moduleId': moduleId,
      'moduleName': moduleName,
      'duration': duration,
      'totalMarks': totalMarks,
      'passMarks': passMarks,
      'terms': terms,
      'questions': questions.map((q) => q.toMap()).toList(),
      'hasRetry': hasRetry,
      'retryDuration': retryDuration,
      'isEnabled': isEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ExamModel copyWith({
    String? examId,
    String? courseId,
    String? moduleId,
    String? moduleName,
    int? duration,
    int? totalMarks,
    int? passMarks,
    List<String>? terms,
    List<ExamQuestionModel>? questions,
    bool? hasRetry,
    String? retryDuration,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return ExamModel(
      examId: examId ?? this.examId,
      courseId: courseId ?? this.courseId,
      moduleId: moduleId ?? this.moduleId,
      moduleName: moduleName ?? this.moduleName,
      duration: duration ?? this.duration,
      totalMarks: totalMarks ?? this.totalMarks,
      passMarks: passMarks ?? this.passMarks,
      terms: terms ?? this.terms,
      questions: questions ?? this.questions,
      hasRetry: hasRetry ?? this.hasRetry,
      retryDuration: retryDuration ?? this.retryDuration,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
