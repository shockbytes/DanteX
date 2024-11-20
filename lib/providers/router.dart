import 'package:dantex/providers/auth.dart';
import 'package:dantex/ui/auth/forgot_password.dart';
import 'package:dantex/ui/auth/sign_in_page.dart';
import 'package:dantex/ui/auth/sign_up_page.dart';
import 'package:dantex/ui/auth/splash_page.dart';
import 'package:dantex/ui/home/home_page.dart';
import 'package:dantex/ui/management/book_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _key = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
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
        path: SignInPage.routeLocation,
        name: SignInPage.routeName,
        builder: (context, state) {
          return const SignInPage();
        },
        routes: [
          GoRoute(
            path: SignUpPage.routeLocation,
            name: SignUpPage.routeName,
            builder: (context, state) {
              return const SignUpPage();
            },
          ),
          GoRoute(
            path: ForgotPasswordPage.routeLocation,
            name: ForgotPasswordPage.routeName,
            builder: (context, state) {
              return const ForgotPasswordPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: BookManagementPage.routeLocation,
        name: BookManagementPage.routeName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const BookManagementPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: curve);

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
        ),
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
        return isAuth ? HomePage.routeLocation : SignInPage.routeLocation;
      }

      final isLoggingIn = state.matchedLocation == SignInPage.routeLocation ||
          state.matchedLocation == SignUpPage.routeLocation;
      if (isLoggingIn) {
        return isAuth ? HomePage.routeLocation : null;
      }

      return null;
    },
  );
}
