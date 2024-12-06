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
    required List<AuthenticationSource> linkedSources,
    required bool emailVerified,
  }) = _DanteUser;
}

enum AuthenticationSource {
  google,
  mail,
  anonymous,
  unknown,
}

extension UserX on User {
  List<AuthenticationSource> get authenticationSources {
    if (isAnonymous) {
      return [AuthenticationSource.anonymous];
    }

    if (providerData.isEmpty) {
      return [AuthenticationSource.unknown];
    }

    return providerData.map((provider) {
      switch (provider.providerId) {
        case 'google.com':
          return AuthenticationSource.google;
        case 'password':
          return AuthenticationSource.mail;
        default:
          return AuthenticationSource.unknown;
      }
    }).toList();
  }
}
