import 'dart:developer';

import 'package:e_cource/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:e_cource/feature/auth/domain/repository/auth_repo.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthProviders with ChangeNotifier {
  final AuthRepo repo;
  final AuthLocalDataSource local;

  AuthProviders(this.repo, this.local);

  AppState loginState = AppState.initial;
  String? error;

  // handle login

  Future<void> handleLogin({
    required String email,
    required String password,
  }) async {
    if (loginState == AppState.loading) return;
    loginState = AppState.loading;
    error = null;
    notifyListeners();

    try {
      await repo.singIn(email: email, password: password);
      // save in localy

      await local.saveLoginKey(email: email);
      log("login key saves succefully");
      loginState = AppState.success;
    } on FirebaseAuthException catch (e) {
      log("fb auth eception : ${e.message}");
      loginState = AppState.error;
      error = firebaseErrorMessage(e.code);
      log("printing firebase error mesage : ${e.message}");
    } catch (e) {
      loginState = AppState.error;
      error = e.toString();

      log("error find from provider file $e");
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await repo.singOut();
    } catch (_) {
      // ignore sign out errors, still clear local login state
    }
    await local.clearKey();
    loginState = AppState.initial;
    error = null;
    notifyListeners();
  }
}

String firebaseErrorMessage(String code) {
  switch (code) {
    case 'user-not-found':
      return "No account found with this email";
    case 'wrong-password':
      return 'Incorrect password';
    case 'invalid-email':
      return 'enter a valid email';
    case 'invalid-credential':
      return 'invalid credintal,try with another.';
    case 'too-many-requests':
      return 'Too many attempts. Try again later';
    case 'No internet connection.':
      return 'No internet connection.';
    default:
      return 'Login failed. Please try again.';
  }
}
