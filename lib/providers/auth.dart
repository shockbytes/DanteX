import 'dart:async';

import 'package:dantex/models/user.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@riverpod
Stream<User?> authStateChanges(Ref ref) =>
    ref.watch(firebaseAuthProvider).authStateChanges();

@riverpod
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn();

@riverpod
Stream<DanteUser?> user(Ref ref) =>
    ref.watch(firebaseAuthProvider).userChanges().asyncMap(
      (user) async {
        if (user == null) {
          return null;
        }

        return DanteUser(
          givenName: user.displayName,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
          authToken: await user.getIdToken(),
          userId: user.uid,
          source: user.authenticationSource,
        );
      },
    );
