import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class DanteUser with _$DanteUser {
  const factory DanteUser({
    required String? givenName,
    required String? displayName,
    required String? email,
    required String? photoUrl,
    required String? authToken,
    required String userId,
    required AuthenticationSource source,
  }) = _DanteUser;
}

enum AuthenticationSource {
  google,
  mail,
  anonymous,
  unknown,
}

extension UserX on User {
  AuthenticationSource get authenticationSource {
    if (isAnonymous) {
      return AuthenticationSource.anonymous;
    }

    if (providerData.isEmpty) {
      return AuthenticationSource.unknown;
    }

    switch (providerData.first.providerId) {
      case 'google.com':
        return AuthenticationSource.google;
      case 'password':
        return AuthenticationSource.mail;
      default:
        return AuthenticationSource.unknown;
    }
  }
}
