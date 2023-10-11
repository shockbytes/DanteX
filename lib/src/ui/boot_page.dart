import 'package:dantex/main.dart';
import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/providers/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BootPage extends ConsumerStatefulWidget {
  const BootPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BootPageState();
}

class _BootPageState extends ConsumerState<BootPage> {
  AuthBloc get _bloc => ref.read(authBlocProvider);

  @override
  void initState() {
    _bloc.isLoggedIn().then(
      (isLoggedIn) {
        String navigationUrl = isLoggedIn ? DanteRoute.dashboard.navigationUrl : DanteRoute.login.navigationUrl;
        context.pushReplacement(navigationUrl);
      },
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
