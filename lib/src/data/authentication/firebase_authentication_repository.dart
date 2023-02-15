import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final FirebaseAuth _fbAuth;

  FirebaseAuthenticationRepository(this._fbAuth);

  @override
  Future<DanteUser?> getAccount() async {
    var fbUser = _fbAuth.currentUser;

    if (fbUser == null) {
      return null;
    }

    return DanteUser(
      givenName: fbUser.displayName,
      displayName: fbUser.displayName,
      email: fbUser.email,
      photoUrl: fbUser.photoURL,
      authToken: await fbUser.getIdToken(false),
      userId: fbUser.uid,
      source: _retrieveAuthenticationSource(fbUser),
    );
  }

  AuthenticationSource _retrieveAuthenticationSource(User user) {
    if (_isAnonymous(user)) {
      return AuthenticationSource.anonymous;
    } else if (_isGoogleUser(user)) {
      return AuthenticationSource.google;
    } else if (_isMailUser(user)) {
      return AuthenticationSource.mail;
    } else {
      return AuthenticationSource.unknown;
    }
  }

  bool _isAnonymous(User user) => user.isAnonymous;

  bool _isGoogleUser(User user) =>
      user.providerData.firstWhereOrNull(
        (provider) => provider.providerId == 'google.com',
      ) !=
      null;

  bool _isMailUser(User user) =>
      user.providerData.firstWhereOrNull(
        (provider) => provider.providerId == 'password',
      ) !=
      null;

  @override
  Future<UserCredential> loginAnonymously() {
    return _fbAuth.signInAnonymously();
  }

  @override
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) {
    return _fbAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> loginWithGoogle() {
    return _fbAuth.signInWithProvider(
      GoogleAuthProvider(),
    );
  }

  @override
  Future<void> logout() {
    return _fbAuth.signOut();
  }

  @override
  Future<List<AuthenticationSource>> fetchSignInMethodsForEmail({
    required String email,
  }) {
    return _fbAuth.fetchSignInMethodsForEmail(email).then(
          (signInMethods) => signInMethods.map((signInMethod) {
            if (signInMethod == 'password') {
              return AuthenticationSource.mail;
            }
            if (signInMethod == 'google.com') {
              return AuthenticationSource.google;
            }
            return AuthenticationSource.unknown;
          }).toList(),
        );
  }

  @override
  Future<UserCredential> createAccountWithMail({
    required String email,
    required String password,
  }) {
    return _fbAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> upgradeAnonymousAccount({
    required String email,
    required String password,
  }) {
    final currentUser = _fbAuth.currentUser;
    if (currentUser == null) {
      throw FirebaseAuthException(
        message:
            'Customer not logged in while trying to perform anonymous upgrade',
        code: 'user-not-found',
      );
    }

    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    return currentUser.linkWithCredential(credential);
  }

  @override
  Future<void> updateMailPassword({required String password}) {
    final currentUser = _fbAuth.currentUser;

    if (currentUser == null) {
      throw FirebaseAuthException(
        message: 'Customer not logged in while trying to update password',
        code: 'user-not-found',
      );
    }
    return currentUser.updatePassword(password);
  }

  @override
  Future<void> sendPasswordResetRequest({required String email}) {
    return _fbAuth.sendPasswordResetEmail(email: email);
  }
}
