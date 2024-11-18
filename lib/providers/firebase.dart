import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

@riverpod
FirebaseApp firebaseApp(Ref ref) => throw UnimplementedError();

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;
