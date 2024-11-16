import 'dart:developer';

import 'package:dantex/providers/auth.dart';
import 'package:dantex/ui/home/dante_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DanteAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Dantex!'),
            Text('${ref.watch(userProvider).value?.source}'),
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
