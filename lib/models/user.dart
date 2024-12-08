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
    required AuthenticationSource primaryAuthenticationSource,
    required bool emailVerified,
  }) = _DanteUser;

  const DanteUser._();

  bool get isAnonymous =>
      primaryAuthenticationSource == AuthenticationSource.anonymous;

  bool get isGoogleUser =>
      primaryAuthenticationSource == AuthenticationSource.google;

  bool get isMailUser =>
      primaryAuthenticationSource == AuthenticationSource.mail;

  bool get isUnknownUser =>
      primaryAuthenticationSource == AuthenticationSource.unknown;
}

enum AuthenticationSource {
  google,
  mail,
  anonymous,
  unknown,
}

extension UserX on User {
  AuthenticationSource get primaryAuthenticationSource {
    if (isAnonymous) {
      return AuthenticationSource.anonymous;
    }

    if (providerData.isEmpty) {
      return AuthenticationSource.unknown;
    }

    if (providerData.any((element) => element.providerId == 'google.com')) {
      return AuthenticationSource.google;
    }

    if (providerData.any((element) => element.providerId == 'password')) {
      return AuthenticationSource.mail;
    }

    return AuthenticationSource.unknown;
  }
}
