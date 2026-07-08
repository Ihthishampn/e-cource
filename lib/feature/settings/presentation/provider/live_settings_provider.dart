import 'dart:developer';

import 'package:e_cource/feature/settings/data/use_case/settings_use_case.dart';
import 'package:e_cource/feature/settings/domain/model/zoom_account_model.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class LiveSettingsProvider with ChangeNotifier {
  final SettingsUseCase useCase;

  LiveSettingsProvider(this.useCase);

  //  Fetch 
  AppState fetchState = AppState.initial;
  List<ZoomAccountModel> zoomAccounts = [];

  Future<void> fetchZoomAccounts() async {
    if (fetchState == AppState.loading) return;

    fetchState = AppState.loading;
    notifyListeners();

    try {
      zoomAccounts = await useCase.getZoomAccounts();
      fetchState = AppState.success;
    } catch (e) {
      log('fetchZoomAccounts error: $e');
      fetchState = AppState.error;
    }

    notifyListeners();
  }

  //  Add 
  AppState addState = AppState.initial;

  Future<bool> addZoomAccount(ZoomAccountModel account) async {
    if (addState == AppState.loading) return false;

    addState = AppState.loading;
    notifyListeners();

    try {
      final docId = await useCase.addZoomAccount(account);
      log('Zoom account added with ID: $docId');
      await fetchZoomAccounts();
      addState = AppState.success;
      notifyListeners();
      return true;
    } catch (e) {
      log('addZoomAccount error: $e');
      addState = AppState.error;
      notifyListeners();
      return false;
    }
  }

  // ---------- Delete ----------
  AppState deleteState = AppState.initial;

  Future<void> deleteZoomAccount(String accountId) async {
    if (deleteState == AppState.loading) return;

    deleteState = AppState.loading;
    notifyListeners();

    try {
      await useCase.deleteZoomAccount(accountId);
      zoomAccounts.removeWhere((a) => a.id == accountId);
      deleteState = AppState.success;
    } catch (e) {
      log('deleteZoomAccount error: $e');
      deleteState = AppState.error;
    }

    notifyListeners();
  }
}
