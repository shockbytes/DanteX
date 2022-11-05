class DanteUser {
  final String? givenName;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? authToken;
  final String userId;
  final AuthenticationSource source;

  DanteUser({
    required this.givenName,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.authToken,
    required this.userId,
    required this.source,
  });
}

enum AuthenticationSource {
  GOOGLE,
  MAIL,
  ANONYMOUS,
  UNKNOWN,
}
