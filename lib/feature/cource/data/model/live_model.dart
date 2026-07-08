import 'package:cloud_firestore/cloud_firestore.dart';

class LiveModel {
  final String id;
  final String title;
  final String courseId;
  final String courseName;
  final String zoomAccountId;
  final String zoomAccountName;
  final String meetingId;
  final String meetingPasscode;
  final String joinUrl;
  final String startUrl;
  final String status;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? endedAt;

  LiveModel({
    required this.id,
    required this.title,
    required this.courseId,
    required this.courseName,
    required this.zoomAccountId,
    required this.zoomAccountName,
    required this.meetingId,
    required this.meetingPasscode,
    required this.joinUrl,
    required this.startUrl,
    required this.status,
    required this.scheduledAt,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
  });

  LiveModel copyWith({
    String? id,
    String? title,
    String? courseId,
    String? courseName,
    String? zoomAccountId,
    String? zoomAccountName,
    String? meetingId,
    String? meetingPasscode,
    String? joinUrl,
    String? startUrl,
    String? status,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return LiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      zoomAccountId: zoomAccountId ?? this.zoomAccountId,
      zoomAccountName: zoomAccountName ?? this.zoomAccountName,
      meetingId: meetingId ?? this.meetingId,
      meetingPasscode: meetingPasscode ?? this.meetingPasscode,
      joinUrl: joinUrl ?? this.joinUrl,
      startUrl: startUrl ?? this.startUrl,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  factory LiveModel.fromMap(Map<String, dynamic> map, String id) {
    return LiveModel(
      id: id,
      title: map['title'] ?? '',
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      zoomAccountId: map['zoomAccountId'] ?? '',
      zoomAccountName: map['zoomAccountName'] ?? '',
      meetingId: map['meetingId'] ?? '',
      meetingPasscode: map['meetingPasscode'] ?? '',
      joinUrl: map['joinUrl'] ?? '',
      startUrl: map['startUrl'] ?? '',
      status: map['status'] ?? 'scheduled',
      scheduledAt: map['scheduledAt'] != null
          ? (map['scheduledAt'] as Timestamp).toDate()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      startedAt: map['startedAt'] != null
          ? (map['startedAt'] as Timestamp).toDate()
          : null,
      endedAt: map['endedAt'] != null
          ? (map['endedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'courseId': courseId,
      'courseName': courseName,
      'zoomAccountId': zoomAccountId,
      'zoomAccountName': zoomAccountName,
      'meetingId': meetingId,
      'meetingPasscode': meetingPasscode,
      'joinUrl': joinUrl,
      'startUrl': startUrl,
      'status': status,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'startedAt': startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
    };
  }
}
