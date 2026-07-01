import 'package:cloud_firestore/cloud_firestore.dart';

class ModuleModel {
  final String moduleId;
  final String courseId;
  final String moduleName;
  final DateTime createdAt;

  const ModuleModel({
    required this.moduleId,
    required this.courseId,
    required this.moduleName,
    required this.createdAt,
  });

  factory ModuleModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ModuleModel(
      moduleId: documentId, 
      courseId: map['courseId'] as String? ?? '',
      moduleName: map['moduleName'] as String? ?? '',
      createdAt: map['createdAt'] is Timestamp 
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'moduleName': moduleName,
      'createdAt': Timestamp.fromDate(createdAt), 
    };
  }

  ModuleModel copyWith({
    String? moduleId,
    String? courseId,
    String? moduleName,
    DateTime? createdAt,
  }) {
    return ModuleModel(
      moduleId: moduleId ?? this.moduleId,
      courseId: courseId ?? this.courseId,
      moduleName: moduleName ?? this.moduleName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}