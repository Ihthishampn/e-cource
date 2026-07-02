import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  

  @lazySingleton
  FirebaseFirestore firebaseFirestore() => FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: "ihthishamecource",
  );

  @lazySingleton
  FirebaseAuth firebaseAuth() => FirebaseAuth.instance;
}
