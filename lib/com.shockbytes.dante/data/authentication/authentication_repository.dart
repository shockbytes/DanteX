import 'package:dantex/com.shockbytes.dante/data/authentication/entity/dante_user.dart';

abstract class AuthenticationRepository {
  Future<DanteUser?> getAccount();

  Future<void> loginWithGoogle();

  Future<void> loginWithEmail({
    required String email,
    required String password,
  });

  Future<void> loginAnonymously();

  Future<void> logout();
}
