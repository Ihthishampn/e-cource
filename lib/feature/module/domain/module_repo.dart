import 'package:e_cource/feature/module/data/model/module_model.dart';

abstract class ModuleRepo {
  // add

  Future<ModuleModel> addModule({required ModuleModel model});

  Future<List<ModuleModel>> getModules(String courseId);
}
