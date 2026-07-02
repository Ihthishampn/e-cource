import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cource/feature/settings/domain/repo/settings_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepo)
class SettingsRepoImpl implements SettingsRepo {
  final FirebaseFirestore firebaseFirestore;

  SettingsRepoImpl(this.firebaseFirestore);

  // ---------------- Privacy Policy ----------------

  @override
  Future<void> privacyUpdate({
    required String header,
    required String description,
  }) async {
    try {
      await firebaseFirestore
          .collection("settings")
          .doc("privacy_policy")
          .set({
        "privacy_header": header,
        "privacy_description": description,
      });
    } catch (e) {
      log("Error updating privacy policy: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> privacyGet() async {
    try {
      final res = await firebaseFirestore
          .collection("settings")
          .doc("privacy_policy")
          .get();

      return res.data() ?? {};
    } catch (e) {
      log("Error getting privacy policy: $e");
      rethrow;
    }
  }

  // ---------------- Terms & Conditions ----------------

  @override
  Future<void> termsAndConditionUpdate({
    required String header,
    required String description,
  }) async {
    try {
      await firebaseFirestore
          .collection("settings")
          .doc("terms_and_condition")
          .set({
        "terms_header": header,
        "terms_description": description,
      });
    } catch (e) {
      log("Error updating terms & conditions: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> termsAndConditionGet() async {
    try {
      final res = await firebaseFirestore
          .collection("settings")
          .doc("terms_and_condition")
          .get();

      return res.data() ?? {};
    } catch (e) {
      log("Error getting terms & conditions: $e");
      rethrow;
    }
  }

  // ---------------- Help & Support ----------------

  @override
  Future<void> helpAndSupportUpdate({
 required String contactNumber,
    required String eMail,
    required String whatsAppNUmber,
  }) async {
    try {
      await firebaseFirestore
          .collection("settings")
          .doc("help_and_support")
          .set({
        "contactNumber": contactNumber,
        "eMail": eMail,
        "whatsAppNUmber": whatsAppNUmber,
      });
    } catch (e) {
      log("Error updating help & support: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> helpAndSupportGet() async {
    try {
      final res = await firebaseFirestore
          .collection("settings")
          .doc("help_and_support")
          .get();

      return res.data() ?? {};
    } catch (e) {
      log("Error getting help & support: $e");
      rethrow;
    }
  }
}