import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nested_navigation/details_screen.dart';
import 'package:nested_navigation/login_screen.dart';
import 'package:nested_navigation/root_screen.dart';

import 'scaffold_with_nested_navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // nested navigation with bottom navigation bar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          // first branch (A)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAKey,
            routes: [
              GoRoute(
                path: '/a',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                      child: RootScreen(
                    label: 'A',
                    detailsPath: '/a/details',
                  ));
                },
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => const DetailsScreen(
                      label: 'A',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // second branch (B)
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBKey,
            routes: [
              GoRoute(
                path: '/b',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                      child: RootScreen(
                    label: 'B',
                    detailsPath: '/b/details',
                  ));
                },
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) {
                      return const DetailsScreen(
                        label: 'B',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
