import 'package:e_cource/feature/app_route/presentation/side_navigation_screen.dart';
import 'package:e_cource/feature/auth/presentation/view/login_screen.dart';
import 'package:e_cource/feature/cource/presentation/view/cource_screen.dart';
import 'package:e_cource/feature/dashboard/presentation/view/dashbpard_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/settings_screen.dart';
import 'package:e_cource/general/core/services/go_route/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorkey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(



  navigatorKey: _rootNavigatorkey,
  initialLocation: RouteNames.loign,

  routes: [
    // OUTER shell
    GoRoute(
      path: RouteNames.loign,
      builder: (context, state) => const LoginScreen(),
    ),

    // main admin routes(shell bar)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return SideNavigationScreen(child: child);
      },
      routes: [
        GoRoute(
          path: RouteNames.dahsboard,
          builder: (context, state) => DashboardScreen(),
        ),

        GoRoute(
          path: RouteNames.cources,
          builder: (context, state) => CourceScreen(),
        ),

        GoRoute(
          path: RouteNames.settings,
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
  ],
);
