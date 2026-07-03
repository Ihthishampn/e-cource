import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AddLessonDialogProvider extends ChangeNotifier {
  Uint8List? pickedVideoBytes;
  String? selectedVideoFileName;
  String? selectedVideoError;

  bool isCalculatingDuration = false;

  void clear() {
    pickedVideoBytes = null;
    selectedVideoFileName = null;
    selectedVideoError = null;
    isCalculatingDuration = false;
    notifyListeners();
  }

  Future<void> pickVideo(TextEditingController minuteController) async {
    log(' pickVideo: opening file picker');
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      log(' pickVideo: no file selected');
      selectedVideoError = 'No file selected.';
      pickedVideoBytes = null;
      selectedVideoFileName = null;
      notifyListeners();
      return;
    }

    final file = result.files.single;
    final rawExtension = file.name.contains('.')
        ? file.name.split('.').last.toLowerCase()
        : '';

    if (rawExtension != 'mp4') {
      log(' pickVideo: invalid extension $rawExtension');
      selectedVideoError = 'Please select a valid MP4 video file.';
      pickedVideoBytes = null;
      selectedVideoFileName = null;
      notifyListeners();
      return;
    }

    if (file.bytes == null || file.bytes!.isEmpty) {
      selectedVideoError = 'Please select a valid MP4 video file.';
      pickedVideoBytes = null;
      selectedVideoFileName = null;
      notifyListeners();
      return;
    }

    pickedVideoBytes = file.bytes;
    selectedVideoFileName = file.name;
    selectedVideoError = null;
    
    isCalculatingDuration = true;
    minuteController.text = 'Calculating...';
    notifyListeners();

    if (kIsWeb && pickedVideoBytes != null) {
      try {
        final blob = html.Blob([pickedVideoBytes!], 'video/mp4');
        final url = html.Url.createObjectUrlFromBlob(blob);
        
        final videoElement = html.VideoElement()
          ..src = url
          ..preload = 'metadata';
          
        final completer = Completer<num>();
        videoElement.onLoadedMetadata.listen((_) {
          if (!completer.isCompleted) completer.complete(videoElement.duration);
        });
        videoElement.onError.listen((_) {
          if (!completer.isCompleted) completer.complete(0.0);
        });
        
        final durationDouble = await completer.future;
        html.Url.revokeObjectUrl(url); 
        
        final durationInSeconds = durationDouble.round();
        log(' pickVideo: Web video duration = $durationInSeconds seconds');
        
        _updateMinuteController(minuteController, durationInSeconds);
      } catch (e) {
        log(' pickVideo: web video duration error $e');
        minuteController.text = '';
      }
    } else if (file.path != null) {
      try {
        final controller = VideoPlayerController.file(File(file.path!));
        await controller.initialize();
        final duration = controller.value.duration;
        await controller.dispose();
        final durationInSeconds = duration.inSeconds;
        
        _updateMinuteController(minuteController, durationInSeconds);
      } catch (e) {
        log(' pickVideo: unable to read video duration $e');
        minuteController.text = '';
      }
    }

    isCalculatingDuration = false;
    notifyListeners();
  }

  void _updateMinuteController(TextEditingController minuteController, int durationInSeconds) {
    if (durationInSeconds > 0) {
      final int hours = durationInSeconds ~/ 3600;
      final int minutes = (durationInSeconds % 3600) ~/ 60;
      final int seconds = durationInSeconds % 60;
      
      if (hours > 0) {
        minuteController.text = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      } else {
        minuteController.text = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    } else {
      minuteController.text = '';
    }
  }
}
