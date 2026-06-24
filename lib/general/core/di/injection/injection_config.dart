import 'package:e_cource/general/core/di/injection/injection_config.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt sl = GetIt.instance;

@injectableInit
Future<void> confirugationDependency() async {
   sl.init();
}
