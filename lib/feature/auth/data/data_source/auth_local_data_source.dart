import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthLocalDataSource {
  final SharedPreferences pref;
  AuthLocalDataSource(this.pref);

  static const String loginKey = "loginKey";

  Future<void> saveLoginKey({required String email}) async {
    await pref.setString(loginKey, email);
  }

  //  get key

  String? getLoginKey() {
    return pref.getString(loginKey);
  }

  // clear key

  Future<void> clearKey() async {
    await pref.remove(loginKey);
  }
}
