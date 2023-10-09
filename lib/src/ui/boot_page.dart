import 'dart:async';

import 'package:dantex/main.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BootPage extends ConsumerStatefulWidget {
  const BootPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BootPageState();
}

class _BootPageState extends ConsumerState<BootPage> {
  @override
  void initState() {
    unawaited(
      ref.read(authenticationRepositoryProvider).getAccount().then((account) {
        final String navigationUrl = account != null
            ? DanteRoute.dashboard.navigationUrl
            : DanteRoute.login.navigationUrl;
        context.pushReplacement(navigationUrl);
      }),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/ic-launcher.jpg',
            width: 96,
            height: 96,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: const LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
