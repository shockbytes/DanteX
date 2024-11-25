import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(),
            ),
            Image.asset(
              'assets/logo/ic-launcher.jpg',
              width: 120,
            ),
          ],
        ),
      ),
    );
  }
}
