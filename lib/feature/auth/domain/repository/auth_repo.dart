abstract class AuthRepo {
  Future<void> singIn({required String email,required String password});
  Future<void> singOut();
}
