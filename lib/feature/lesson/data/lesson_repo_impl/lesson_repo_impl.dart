import 'dart:developer';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_cource/feature/lesson/data/model/lesson_model.dart';
import 'package:e_cource/feature/lesson/domain/lesson_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LessonRepo)
class LessonRepoImpl implements LessonRepo {
  final FirebaseFirestore firebaseFirestore;
  final Dio dio;

  LessonRepoImpl(this.firebaseFirestore, this.dio);

  @override
  Future<LessonModel> addLesson({
    required LessonModel model,
    Uint8List? videoBytes,
    String? fileName,
    void Function(double progress)? onProgress,
  }) async {
    try {
      log(
        '[LessonRepoImpl] addLesson: enter for lesson="${model.lessonTitle}"',
      );

      if (videoBytes == null || fileName == null) {
        log('[LessonRepoImpl] addLesson: missing videoBytes or fileName');
        throw Exception(
          'Please select a valid MP4 video file before uploading.',
        );
      }

      final apiDoc = await firebaseFirestore
          .collection('general')
          .doc('bunny_api_key')
          .get();
      final cdnDoc = await firebaseFirestore
          .collection('general')
          .doc('cdn_host_name')
          .get();
      final libraryDoc = await firebaseFirestore
          .collection('general')
          .doc('libary_id')
          .get();

      final apiKey = apiDoc.data()?['bunny_player_api_key']?.toString() ?? '';
      final cdnHost = cdnDoc.data()?['cdn_bunny_host_name']?.toString() ?? '';
      final libraryId = libraryDoc.data()?['vedio_libary_id']?.toString() ?? '';

      log(
        '[LessonRepoImpl] addLesson: fetched Bunny config apiKey=${apiKey.isNotEmpty}, cdnHost=$cdnHost, libraryId=$libraryId',
      );

      if (apiKey.isEmpty || libraryId.isEmpty) {
        throw Exception('Bunny configuration missing in Firestore.');
      }

      final endpoint = '/library/$libraryId/videos';
      log('[LessonRepoImpl] addLesson: creating video record at $endpoint');

      final createResponse = await dio.post(
        endpoint,
        data: {'title': model.lessonTitle},
        options: Options(
          headers: {
            'AccessKey': apiKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (createResponse.statusCode == null ||
          createResponse.statusCode! < 200 ||
          createResponse.statusCode! >= 300) {
        throw Exception('Bunny create video failed: ${createResponse.statusMessage}');
      }

      final createData = createResponse.data is Map<String, dynamic>
          ? createResponse.data as Map<String, dynamic>
          : <String, dynamic>{};

      final videoId =
          createData['guid']?.toString() ??
          createData['videoId']?.toString() ??
          '';

      if (videoId.isEmpty) {
        throw Exception('Failed to get video ID from BunnyCDN.');
      }

      final uploadEndpoint = '/library/$libraryId/videos/$videoId';
      log(
        '[LessonRepoImpl] addLesson: starting upload to $uploadEndpoint, filename=$fileName, bytes=${videoBytes.lengthInBytes}',
      );

      final uploadResponse = await dio.put(
        uploadEndpoint,
        data: Stream.fromIterable([videoBytes]), // send raw bytes
        options: Options(
          headers: {
            'AccessKey': apiKey,
            'Content-Type': 'application/octet-stream',
          },
        ),
        onSendProgress: (sent, total) {
          if (total > 0) {
            final prog = (sent / total).clamp(0.0, 1.0);
            log(
              '[LessonRepoImpl] upload onSendProgress: sent=$sent total=$total progress=${(prog * 100).toStringAsFixed(1)}%',
            );
            onProgress?.call(prog);
          } else {
             // fallback progress if total is not known, but we know length
             final prog = (sent / videoBytes.lengthInBytes).clamp(0.0, 1.0);
             onProgress?.call(prog);
          }
        },
      );

      log(
        '[LessonRepoImpl] addLesson: upload completed with status=${uploadResponse.statusCode}',
      );

      if (uploadResponse.statusCode == null ||
          uploadResponse.statusCode! < 200 ||
          uploadResponse.statusCode! >= 300) {
        throw Exception('Bunny upload failed: ${uploadResponse.statusMessage}');
      }

      final responseData = createData; // The create response has the thumbnail URL

      final playbackUrl = cdnHost.isNotEmpty
          ? 'https://$cdnHost/play/$videoId'
          : '';
      final thumbnailUrl = responseData['thumbnailUrl']?.toString() ?? '';

      log(
        '[LessonRepoImpl] addLesson: playbackUrl=$playbackUrl thumbnailUrl=$thumbnailUrl',
      );

      final updatedVideos = model.videos.map((video) {
        return video.copyWith(
          videoId: videoId.isNotEmpty ? videoId : video.videoId,
          videoUrl: playbackUrl.isNotEmpty ? playbackUrl : video.videoUrl,
          thumbnailUrl: thumbnailUrl.isNotEmpty
              ? thumbnailUrl
              : video.thumbnailUrl,
        );
      }).toList();

      final DocumentReference doc = firebaseFirestore
          .collection('lessons')
          .doc();
      final newLesson = model.copyWith(lessonId: doc.id, videos: updatedVideos);

      final data = newLesson.toMap();
      data['bunny'] = {
        'videoId': videoId,
        'playbackUrl': playbackUrl,
        'thumbnailUrl': thumbnailUrl,
        'cdnHost': cdnHost,
        'libraryId': libraryId,
      };

      log('[LessonRepoImpl] addLesson: writing lesson doc id=${doc.id}');
      await doc.set(data);
      log(
        '[LessonRepoImpl] addLesson: firestore write complete for id=${doc.id}',
      );

      return newLesson;
    } catch (e) {
      log("error while add lesson $e");

      rethrow;
    }
  }

  @override
  Future<List<LessonModel>> getLesson(String courseId) async {
    try {
      final res = await firebaseFirestore
          .collection("lessons")
          .where("courseId", isEqualTo: courseId)
          .orderBy("createdAt")
          .get();

      return res.docs.map((e) => LessonModel.fromMap(e.data(), e.id)).toList();
    } catch (e) {
      log("error while get lessons $e");
      rethrow;
    }
  }

  @override
  Future<bool> changeIspreView({
    required bool val,
    required String lesssonId,
    required String videoId,
  }) async {
    try {
      final docRef = firebaseFirestore.collection("lessons").doc(lesssonId);

      final snapshot = await docRef.get();

      if (!snapshot.exists) return false;

      final data = snapshot.data()!;
      final lesson = LessonModel.fromMap(data, snapshot.id);

      final updatedVideos = lesson.videos.map((video) {
        if (video.videoId == videoId) {
          return video.copyWith(isPreview: val);
        }
        return video;
      }).toList();

      await docRef.update({
        "videos": updatedVideos.map((e) => e.toMap()).toList(),
      });

      return true;
    } catch (e) {
      log("error: $e");
      return false;
    }
  }
}
