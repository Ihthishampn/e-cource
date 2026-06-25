import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/auth/domain/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;

  AuthRepoImpl(this.auth, this.firebaseFirestore);

  @override
  Future<void> singIn({required String email, required String password}) async {
    try {
      final UserCredential cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = cred.user?.uid;

      log("login success user id: $userId");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> singOut() async {
    await auth.signOut();
    
  }
}
