import 'package:dantex/auth.dart';
import 'package:dantex/ui/home_page.dart';
import 'package:dantex/ui/login/login_page.dart';
import 'package:dantex/ui/login/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authStateChanges = ref.watch(authStateChangesProvider);

  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: SplashPage.routeLocation,
    routes: [
      GoRoute(
        path: SplashPage.routeLocation,
        name: SplashPage.routeName,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: HomePage.routeLocation,
        name: HomePage.routeName,
        builder: (context, state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: LoginPage.routeLocation,
        name: LoginPage.routeName,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authStateChanges.isLoading || authStateChanges.hasError) {
        return null;
      }

      // Here we guarantee that hasData == true, i.e. we have a readable value
      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authStateChanges.valueOrNull != null;

      final isSplash = state.matchedLocation == SplashPage.routeLocation;
      if (isSplash) {
        return isAuth ? HomePage.routeLocation : LoginPage.routeLocation;
      }

      final isLoggingIn = state.matchedLocation == LoginPage.routeLocation;
      if (isLoggingIn) {
        return isAuth ? HomePage.routeLocation : null;
      }

      return isAuth ? null : SplashPage.routeLocation;
    },
  );
});
