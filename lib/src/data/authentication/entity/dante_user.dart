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

  @override
  bool operator ==(Object other) {
    return other is DanteUser &&
        other.givenName == givenName &&
        other.displayName == displayName &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.authToken == authToken &&
        other.userId == userId &&
        other.source == source;
  }

  @override
  int get hashCode => Object.hash(
        givenName,
        displayName,
        email,
        photoUrl,
        authToken,
        userId,
        source,
      );
}

enum AuthenticationSource {
  google,
  mail,
  anonymous,
  unknown,
}
