import 'dart:developer';

import 'package:e_cource/feature/settings/data/use_case/settings_use_case.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsProvider with ChangeNotifier {
  final SettingsUseCase useCase;

  SettingsProvider(this.useCase);

  //  Privacy Policy

  AppState privacyGetState = AppState.initial;
  AppState privacyUpdateState = AppState.initial;

  Map<String, dynamic> privacyData = {};

  Future<void> getPrivacyPolicy() async {
    if (privacyGetState == AppState.loading) return;

    privacyGetState = AppState.loading;
    notifyListeners();

    try {
      privacyData = await useCase.privacyGet();
      privacyGetState = AppState.success;
    } catch (e) {
      log("Privacy Get Error: $e");
      privacyGetState = AppState.error;
    }

    notifyListeners();
  }

  Future<void> updatePrivacyPolicy({
    required String header,
    required String description,
  }) async {
    if (privacyUpdateState == AppState.loading) return;

    privacyUpdateState = AppState.loading;
    notifyListeners();

    try {
      await useCase.privacyUpdate(header: header, description: description);

      privacyData = {
        "privacy_heder": header,
        "privacy_description": description,
      };

      privacyUpdateState = AppState.success;
    } catch (e) {
      log("Privacy Update Error: $e");
      privacyUpdateState = AppState.error;
    }

    notifyListeners();
  }

  //  Terms & Conditions

  AppState termsGetState = AppState.initial;
  AppState termsUpdateState = AppState.initial;

  Map<String, dynamic> termsData = {};

  Future<void> getTermsAndCondition() async {
    if (termsGetState == AppState.loading) return;

    termsGetState = AppState.loading;
    notifyListeners();

    try {
      termsData = await useCase.termsAndConditionGet();
      termsGetState = AppState.success;
    } catch (e) {
      log("Terms Get Error: $e");
      termsGetState = AppState.error;
    }

    notifyListeners();
  }

  Future<void> updateTermsAndCondition({
    required String header,
    required String description,
  }) async {
    if (termsUpdateState == AppState.loading) return;

    termsUpdateState = AppState.loading;
    notifyListeners();

    try {
      await useCase.termsAndConditionUpdate(
        header: header,
        description: description,
      );

      termsData = {
        "terms_and_condition_header": header,
        "terms_and_condition_description": description,
      };

      termsUpdateState = AppState.success;
    } catch (e) {
      log("Terms Update Error: $e");
      termsUpdateState = AppState.error;
    }

    notifyListeners();
  }

  //  Help & Support

  AppState helpGetState = AppState.initial;
  AppState helpUpdateState = AppState.initial;

  Map<String, dynamic> helpData = {};

  Future<void> getHelpAndSupport() async {
    if (helpGetState == AppState.loading) return;

    helpGetState = AppState.loading;
    notifyListeners();

    try {
      helpData = await useCase.helpAndSupportGet();
      helpGetState = AppState.success;
    } catch (e) {
      log("Help Get Error: $e");
      helpGetState = AppState.error;
    }

    notifyListeners();
  }

  Future<void> updateHelpAndSupport({
   required String contactNumber,
    required String eMail,
    required String whatsAppNUmber,
  }) async {
    if (helpUpdateState == AppState.loading) return;

    helpUpdateState = AppState.loading;
    notifyListeners();

    try {
      await useCase.helpAndSupportUpdate(
        contactNumber: contactNumber,
        eMail: eMail,
        whatsAppNUmber: whatsAppNUmber,
      );
      helpData = {
        "contactNumber": contactNumber,
        "eMail": eMail,
        "whatsAppNUmber": whatsAppNUmber,
      };

      helpUpdateState = AppState.success;
    } catch (e) {
      log("Help Update Error: $e");
      helpUpdateState = AppState.error;
    }

    notifyListeners();
  }
}
