import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/add/scan_book_page.dart';
import 'package:dantex/src/ui/book/book_detail_page.dart';
import 'package:dantex/src/ui/book/book_notes_page.dart';
import 'package:dantex/src/ui/boot_page.dart';
import 'package:dantex/src/ui/core/dante_page_scaffold.dart';
import 'package:dantex/src/ui/login/email_login_page.dart';
import 'package:dantex/src/ui/login/login_page.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:dantex/src/ui/management/book_management_page.dart';
import 'package:dantex/src/ui/profile/profile_page.dart';
import 'package:dantex/src/ui/recommendations/recommendations_page.dart';
import 'package:dantex/src/ui/search/search_page.dart';
import 'package:dantex/src/ui/settings/contributors_page.dart';
import 'package:dantex/src/ui/settings/settings_page.dart';
import 'package:dantex/src/ui/stats/stats_page.dart';
import 'package:dantex/src/ui/timeline/timeline_page.dart';
import 'package:dantex/src/ui/wishlist/wishlist_page.dart';
import 'package:flutter/foundation.dart';
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
            ? DanteRoute.library.navigationUrl
            : DanteRoute.login.navigationUrl;
      }

      final isLoggingIn =
          state.uri.toString() == DanteRoute.login.navigationUrl ||
              state.uri.toString() == DanteRoute.emailLogin.navigationUrl;
      if (isLoggingIn) {
        return isAuth ? DanteRoute.library.navigationUrl : null;
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
      _buildMainRoutes(),
    ],
  );
}

/// TODO Explain difference of web and mobile routing
RouteBase _buildMainRoutes() {
  return kIsWeb ? _buildWebMainRoute() : _buildMobileMainRoute();
}

RouteBase _buildMobileMainRoute() {
  return GoRoute(
    path: DanteRoute.library.url,
    builder: (BuildContext context, GoRouterState state) => const MainPage(),
    routes: _mainRoutes,
  );
}

RouteBase _buildWebMainRoute() {
  return ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      return DantePageScaffold(content: child);
    },
    routes: [
      GoRoute(
        path: DanteRoute.library.url,
        builder: (BuildContext context, GoRouterState state) =>
            const MainPage(),
      ),
      ..._mainRoutes,
    ],
  );
}

List<RouteBase> _mainRoutes = [
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
    builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
  ),
  GoRoute(
    path: DanteRoute.statistics.url,
    builder: (BuildContext context, GoRouterState state) => const StatsPage(),
  ),
  GoRoute(
    path: DanteRoute.search.url,
    builder: (BuildContext context, GoRouterState state) => const SearchPage(),
  ),
  GoRoute(
    path: DanteRoute.timeline.url,
    builder: (BuildContext context, GoRouterState state) =>
        const TimelinePage(),
  ),
  GoRoute(
    path: DanteRoute.wishlist.url,
    builder: (BuildContext context, GoRouterState state) =>
        const WishlistPage(),
  ),
  GoRoute(
    path: DanteRoute.recommendations.url,
    builder: (BuildContext context, GoRouterState state) =>
        const RecommendationsPage(),
  ),
  GoRoute(
    path: DanteRoute.bookManagement.url,
    builder: (BuildContext context, GoRouterState state) =>
        const BookManagementPage(),
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
  GoRoute(
    path: DanteRoute.bookNotes.url,
    builder: (context, state) {
      final bookId = state.pathParameters['bookId'] ?? '';
      return BookNotesPage(id: bookId);
    },
  ),
];

enum DanteRoute {
  boot(
    webUrl: '/boot',
    mobileUrl: '/boot',
    navigationUrl: '/boot',
  ),
  login(
    webUrl: '/login',
    mobileUrl: '/login',
    navigationUrl: '/login',
  ),
  emailLogin(
    webUrl: 'email',
    mobileUrl: 'email',
    navigationUrl: '/login/email',
  ),
  library(
    webUrl: '/',
    mobileUrl: '/',
    navigationUrl: '/',
  ),
  scanBook(
    webUrl: '/scan',
    mobileUrl: 'scan',
    navigationUrl: '/scan',
  ),
  settings(
    webUrl: '/settings',
    mobileUrl: 'settings',
    navigationUrl: '/settings',
  ),
  search(
    webUrl: '/search',
    mobileUrl: 'search',
    navigationUrl: '/search',
  ),
  contributors(
    webUrl: 'contributors',
    mobileUrl: 'contributors',
    navigationUrl: '/settings/contributors',
  ),
  profile(
    webUrl: '/profile',
    mobileUrl: 'profile',
    navigationUrl: '/profile',
  ),
  statistics(
    webUrl: '/statistics',
    mobileUrl: 'statistics',
    navigationUrl: '/statistics',
  ),
  timeline(
    webUrl: '/timeline',
    mobileUrl: 'timeline',
    navigationUrl: '/timeline',
  ),
  wishlist(
    webUrl: '/wishlist',
    mobileUrl: 'wishlist',
    navigationUrl: '/wishlist',
  ),
  recommendations(
    webUrl: '/recommendations',
    mobileUrl: 'recommendations',
    navigationUrl: '/recommendations',
  ),
  bookManagement(
    webUrl: '/management',
    mobileUrl: 'management',
    navigationUrl: '/management',
  ),
  bookDetail(
    webUrl: '/book/:bookId',
    mobileUrl: 'book/:bookId',
    navigationUrl: '/book/:bookId',
  ),
  bookNotes(
    webUrl: '/book/:bookId/notes',
    mobileUrl: 'book/:bookId/notes',
    navigationUrl: '/book/:bookId/notes',
  );

  /// Url used for registering the route in the [_router] field for Web.
  final String _webUrl;

  /// Url used for registering the route in the [_router] field for Mobile.
  final String _mobileUrl;

  /// Used for navigating to another screen, when calling context.go()
  final String _navigationUrl;

  String get url => kIsWeb ? _webUrl : _mobileUrl;

  String get navigationUrl => _navigationUrl;

  const DanteRoute({
    required String webUrl,
    required String mobileUrl,
    required String navigationUrl,
  })  : _webUrl = webUrl,
        _mobileUrl = mobileUrl,
        _navigationUrl = navigationUrl;
}
