import 'package:dantex/src/data/authentication/entity/dante_user.dart';

abstract class AuthenticationRepository {
  Stream<DanteUser?> get authStateChanges;

  Future<DanteUser?> getAccount();

  Future<void> loginWithGoogle();

  Future<void> loginWithEmail({
    required String email,
    required String password,
  });

  Future<void> loginAnonymously();

  Future<void> logout();

  Future<void> deleteAccount();

  Future<List<AuthenticationSource>> fetchSignInMethodsForEmail({
    required String email,
  });

  Future<void> createAccountWithMail({
    required String email,
    required String password,
  });

  Future<void> upgradeAnonymousAccount({
    required String email,
    required String password,
  });

  Future<void> updateMailPassword({
    required String password,
  });

  Future<void> sendPasswordResetRequest({
    required String email,
  });
}
