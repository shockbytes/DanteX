import 'dart:async';

import 'package:dantex/src/bloc/auth/login_bloc.dart';
import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginBloc _bloc = DependencyInjector.get<LoginBloc>();
  late StreamSubscription<LoginEvent> _loginSubscription;

  @override
  void initState() {
    super.initState();
    _loginSubscription = _bloc.loginEvents.listen(
      _loginEventReceived,
      onError: (error, stackTrace) => _loginErrorReceived(error, stackTrace),
    );
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  void _loginErrorReceived(Error error, StackTrace stackTrace) {
    // TODO: Handle login errors
  }

  void _loginEventReceived(LoginEvent event) {
    Get.to(() => const MainPage());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: DanteColors.accent),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: DanteColors.background,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/ic-launcher.jpg',
                  width: 92,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Login with your account to synchronize your books with other devices.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => _bloc.loginWithGoogle(),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                      ),
                      Expanded(
                        child: Text(
                          'Login with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _bloc.loginWithEmail(),
                  child: Row(
                    children: const [
                      Icon(Icons.mail_outline),
                      Expanded(
                        child: Text(
                          'Login with Email',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  height: 2,
                  color: DanteColors.accent,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _bloc.loginAnonymously(),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.no_accounts_outlined,
                        color: DanteColors.textPrimary,
                      ),
                      Expanded(
                        child: Text(
                          'Stay anonymous',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DanteColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
