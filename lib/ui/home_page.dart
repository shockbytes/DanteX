import 'dart:developer';

import 'package:dantex/data/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                await ref.read(firebaseAuthProvider).signOut();
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
