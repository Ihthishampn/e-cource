import 'dart:developer';

import 'package:e_cource/feature/module/data/model/module_model.dart';
import 'package:e_cource/feature/module/data/module_use_case/module_use_case.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class ModuleProvider with ChangeNotifier {
  final ModuleUseCase useCase;
  ModuleProvider(this.useCase);
  AppState addMpoduleState = AppState.initial;
  AppState fetchpoduleState = AppState.initial;

  String? addModuleerror;
  String? fetchModuleerror;

  List<ModuleModel> moduleList = [];

  Future<void> handleAddModule(ModuleModel model) async {
    if (addMpoduleState == AppState.loading) return;
    addMpoduleState = AppState.loading;
    addModuleerror = null;
    notifyListeners();

    try {
      final res = await useCase.addModule(model: model);

      moduleList.add(res);

      addMpoduleState = AppState.success;
    } catch (e) {
      log("error from add module provider : $e");

      addMpoduleState = AppState.error;
    }

    notifyListeners();
  }

  Future<void> handleFetch(String courseId) async {
    if (fetchpoduleState == AppState.loading) return;
    moduleList.clear();
    fetchpoduleState = AppState.loading;
    fetchModuleerror = null;
    notifyListeners();

    try {
      moduleList = await useCase.getModules(courseId);

      fetchpoduleState = AppState.success;
    } catch (e) {
      log("error from fetch module provider : $e");

      fetchpoduleState = AppState.error;
      fetchModuleerror = e.toString();
    }

    notifyListeners();
  }

  void clear() {
  moduleList.clear();
  fetchpoduleState = AppState.initial;
  fetchModuleerror = null;
  notifyListeners();
}
}
