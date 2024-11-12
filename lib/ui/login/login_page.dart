import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(onPressed: () {}, child: const Text('Email Login')),
            OutlinedButton(
              onPressed: () async {
                final googleUser = await GoogleSignIn().signIn();

                final googleAuth = await googleUser?.authentication;

                final credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth?.accessToken,
                  idToken: googleAuth?.idToken,
                );

                await FirebaseAuth.instance.signInWithCredential(credential);
              },
              child: const Text('Google Login'),
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  final userCredential =
                      await FirebaseAuth.instance.signInAnonymously();
                  log('Signed in with temporary account. $userCredential');
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'operation-not-allowed':
                      log(
                        "Anonymous auth hasn't been enabled for this project.",
                      );
                    default:
                      log('Unknown error.');
                  }
                }
              },
              child: const Text('Anonymous Login'),
            ),
          ],
        ),
      ),
    );
  }
}
