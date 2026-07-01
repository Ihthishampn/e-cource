import 'package:e_cource/feature/module/data/model/module_model.dart';
import 'package:e_cource/feature/module/domain/module_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ModuleUseCase {
  final ModuleRepo repo;

  ModuleUseCase(this.repo);

  Future<ModuleModel> addModule({required ModuleModel model}) async {
    return await repo.addModule(model: model);
  }

  Future<List<ModuleModel>> getModules(String courseId) async {
    return await repo.getModules(courseId);
  }
}
