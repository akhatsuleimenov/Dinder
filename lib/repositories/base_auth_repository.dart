import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthrepository {
  Stream<auth.User?> get user;
  Future<auth.User?> signUp({
    required String email,
    required String password,
  });
}
