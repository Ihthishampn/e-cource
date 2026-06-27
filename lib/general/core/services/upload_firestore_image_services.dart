import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

Future<String?> uplodFirebaseImageService(Uint8List image) async {
  log("image service start to try");

  try {
    var storage = FirebaseStorage.instance;

    Reference ref = storage
        .ref()
        .child("course_category_images_ihthisham")
        .child('${Timestamp.now().millisecondsSinceEpoch}.jpeg');

    final value = await ref.putData(
      image,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return await value.ref.getDownloadURL();
  } catch (e) {
    showErrorToast(error: e.toString());

    return null;
  }
}
