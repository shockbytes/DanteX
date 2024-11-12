import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@riverpod
Stream<User?> authStateChanges(Ref ref) =>
    FirebaseAuth.instance.authStateChanges();
