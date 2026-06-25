import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class GoRouterRefreshStreamAuth extends ChangeNotifier {
  String? _lastUid;
  late final StreamSubscription<User?> _subscription;

  GoRouterRefreshStreamAuth(Stream<User?> stream) {
    _lastUid = FirebaseAuth.instance.currentUser?.uid;
    _subscription = stream.listen((User? user) {
      final currentUid = user?.uid;
      if (currentUid != _lastUid) {
        _lastUid = currentUid;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
