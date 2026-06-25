// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:e_cource/feature/auth/data/data_source/auth_local_data_source.dart'
    as _i408;
import 'package:e_cource/feature/auth/data/repo_impl/auth_repo_impl.dart'
    as _i632;
import 'package:e_cource/feature/auth/domain/repository/auth_repo.dart'
    as _i292;
import 'package:e_cource/feature/auth/presentation/provider/auth_provider.dart'
    as _i966;
import 'package:e_cource/general/core/di/module/firebase_module.dart' as _i973;
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
    final firebaseModule = _$FirebaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localStorageModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => firebaseModule.firebaseFirestore(),
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth());
    gh.lazySingleton<_i292.AuthRepo>(
      () => _i632.AuthRepoImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i408.AuthLocalDataSource>(
      () => _i408.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i966.AuthProviders>(
      () => _i966.AuthProviders(
        gh<_i292.AuthRepo>(),
        gh<_i408.AuthLocalDataSource>(),
      ),
    );
    return this;
  }
}

class _$LocalStorageModule extends _i63.LocalStorageModule {}

class _$FirebaseModule extends _i973.FirebaseModule {}
