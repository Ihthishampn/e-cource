// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:e_cource/feature/auth/data/data_source/auth_local_data_source.dart'
    as _i408;
import 'package:e_cource/feature/auth/data/repo_impl/auth_repo_impl.dart'
    as _i632;
import 'package:e_cource/feature/auth/domain/repository/auth_repo.dart'
    as _i292;
import 'package:e_cource/feature/auth/presentation/provider/auth_provider.dart'
    as _i966;
import 'package:e_cource/feature/cource/data/repo_impl/course_repo_impl.dart'
    as _i618;
import 'package:e_cource/feature/cource/data/use_case/course_category_use_case.dart'
    as _i903;
import 'package:e_cource/feature/cource/domain/course_repo.dart' as _i106;
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart'
    as _i342;
import 'package:e_cource/feature/lesson/data/lesson_repo_impl/lesson_repo_impl.dart'
    as _i1057;
import 'package:e_cource/feature/lesson/data/lesson_use_case/lesson_use_case.dart'
    as _i799;
import 'package:e_cource/feature/lesson/domain/lesson_repo.dart' as _i529;
import 'package:e_cource/feature/lesson/presentation/provider/lesson_provider.dart'
    as _i794;
import 'package:e_cource/feature/module/data/module_repo_impl/module_repo_impl.dart'
    as _i612;
import 'package:e_cource/feature/module/data/module_use_case/module_use_case.dart'
    as _i967;
import 'package:e_cource/feature/module/domain/module_repo.dart' as _i824;
import 'package:e_cource/feature/module/presentation/provider/module_provider.dart'
    as _i5;
import 'package:e_cource/feature/settings/data/repo_impl/settings_repo_impl.dart'
    as _i86;
import 'package:e_cource/feature/settings/data/use_case/settings_use_case.dart'
    as _i1069;
import 'package:e_cource/feature/settings/domain/repo/settings_repo.dart'
    as _i973;
import 'package:e_cource/feature/settings/presentation/provider/settings_provider.dart'
    as _i116;
import 'package:e_cource/general/core/di/module/dio_client.dart' as _i733;
import 'package:e_cource/general/core/di/module/firebase_module.dart' as _i975;
import 'package:e_cource/general/core/di/module/local_storage_module.dart'
    as _i63;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final localStorageModule = _$LocalStorageModule();
    final dioClient = _$DioClient();
    final firebaseModule = _$FirebaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localStorageModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => dioClient.dio());
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseModule.firebaseFirestore(),
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth());
    gh.lazySingleton<_i106.CourseRepo>(
      () => _i618.CourseRepoImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i973.SettingsRepo>(
      () => _i86.SettingsRepoImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i292.AuthRepo>(
      () => _i632.AuthRepoImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i529.LessonRepo>(
      () => _i1057.LessonRepoImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i408.AuthLocalDataSource>(
      () => _i408.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i903.CourseCategoryUseCase>(
      () => _i903.CourseCategoryUseCase(gh<_i106.CourseRepo>()),
    );
    gh.factory<_i966.AuthProviders>(
      () => _i966.AuthProviders(
        gh<_i292.AuthRepo>(),
        gh<_i408.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i824.ModuleRepo>(
      () => _i612.ModuleRepoImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i342.CourseFirebaseProvider>(
      () => _i342.CourseFirebaseProvider(gh<_i903.CourseCategoryUseCase>()),
    );
    gh.lazySingleton<_i799.LessonUseCase>(
      () => _i799.LessonUseCase(gh<_i529.LessonRepo>()),
    );
    gh.lazySingleton<_i1069.SettingsUseCase>(
      () => _i1069.SettingsUseCase(gh<_i973.SettingsRepo>()),
    );
    gh.lazySingleton<_i967.ModuleUseCase>(
      () => _i967.ModuleUseCase(gh<_i824.ModuleRepo>()),
    );
    gh.factory<_i5.ModuleProvider>(
      () => _i5.ModuleProvider(gh<_i967.ModuleUseCase>()),
    );
    gh.factory<_i794.LessonProvider>(
      () => _i794.LessonProvider(gh<_i799.LessonUseCase>()),
    );
    gh.factory<_i116.SettingsProvider>(
      () => _i116.SettingsProvider(gh<_i1069.SettingsUseCase>()),
    );
    return this;
  }
}

class _$LocalStorageModule extends _i63.LocalStorageModule {}

class _$DioClient extends _i733.DioClient {}

class _$FirebaseModule extends _i975.FirebaseModule {}
