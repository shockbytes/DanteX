import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/add/scan_book_page.dart';
import 'package:dantex/src/ui/book/book_detail_page.dart';
import 'package:dantex/src/ui/boot_page.dart';
import 'package:dantex/src/ui/core/dante_page_scaffold.dart';
import 'package:dantex/src/ui/login/email_login_page.dart';
import 'package:dantex/src/ui/login/login_page.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:dantex/src/ui/profile/profile_page.dart';
import 'package:dantex/src/ui/search/search_page.dart';
import 'package:dantex/src/ui/settings/contributors_page.dart';
import 'package:dantex/src/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _key = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authStateChangesProvider);
  return GoRouter(
    navigatorKey: _key,
    initialLocation: DanteRoute.boot.navigationUrl,
    redirect: (context, state) async {
      // If our async state is loading, don't perform redirects, yet
      if (authState.isLoading || authState.hasError) return null;

      // This has to do with how the FirebaseAuth SDK handles the "log-in" state
      // Returning `null` means "we are not authorized"
      final isAuth = authState.valueOrNull != null;

      final isSplash = state.uri.toString() == DanteRoute.boot.navigationUrl;
      if (isSplash) {
        return isAuth
            ? DanteRoute.dashboard.navigationUrl
            : DanteRoute.login.navigationUrl;
      }

      final isLoggingIn =
          state.uri.toString() == DanteRoute.login.navigationUrl ||
              state.uri.toString() == DanteRoute.emailLogin.navigationUrl;
      if (isLoggingIn) {
        return isAuth ? DanteRoute.dashboard.navigationUrl : null;
      }

      return isAuth ? null : DanteRoute.boot.navigationUrl;
    },
    routes: [
      GoRoute(
        path: DanteRoute.boot.url,
        builder: (BuildContext context, GoRouterState state) =>
            const BootPage(),
      ),
      GoRoute(
        path: DanteRoute.login.url,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
        routes: [
          GoRoute(
            path: DanteRoute.emailLogin.url,
            builder: (BuildContext context, GoRouterState state) =>
                const EmailLoginPage(),
          ),
        ],
      ),
      GoRoute(
        path: DanteRoute.dashboard.url,
        builder: (BuildContext context, GoRouterState state) =>
            const MainPage(),
        routes: [
          GoRoute(
            path: DanteRoute.settings.url,
            builder: (BuildContext context, GoRouterState state) =>
                const SettingsPage(),
            routes: [
              GoRoute(
                path: DanteRoute.contributors.url,
                builder: (BuildContext context, GoRouterState state) =>
                    const ContributorsPage(),
              ),
            ],
          ),
          GoRoute(
            path: DanteRoute.profile.url,
            builder: (BuildContext context, GoRouterState state) =>
                const ProfilePage(),
          ),
          GoRoute(
            path: DanteRoute.scanBook.url,
            builder: (BuildContext context, GoRouterState state) =>
                const ScanBookPage(),
          ),
          GoRoute(
            path: DanteRoute.bookDetail.url,
            builder: (context, state) {
              final bookId = state.pathParameters['bookId'] ?? '';
              return BookDetailPage(id: bookId);
            },
          ),
        ],
      ),
    ],
  );
}

enum DanteRoute {
  boot(
    url: '/boot',
    navigationUrl: '/boot',
  ),
  login(
    url: '/login',
    navigationUrl: '/login',
  ),
  emailLogin(
    url: 'email',
    navigationUrl: '/login/email',
  ),
  dashboard(
    url: '/',
    navigationUrl: '/',
  ),
  scanBook(
    url: '/scan',
    navigationUrl: '/scan',
  ),
  settings(
    url: '/settings',
    navigationUrl: '/settings',
  ),
  search(
    url: 'search',
    navigationUrl: '/search',
  ),
  contributors(
    url: 'contributors',
    navigationUrl: '/settings/contributors',
  ),
  profile(
    url: '/profile',
    navigationUrl: '/profile',
  ),
  bookDetail(
    url: '/book/:bookId',
    navigationUrl: '/book/:bookId',
  );

  /// Url used for registering the route in the [_router] field.
  final String url;

  /// Used for navigating to another screen, when calling context.go()
  final String navigationUrl;

  const DanteRoute({
    required this.url,
    required this.navigationUrl,
  });
}
