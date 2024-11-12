import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dantex'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Dantex!'),
            OutlinedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                log('Signed out.');
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
