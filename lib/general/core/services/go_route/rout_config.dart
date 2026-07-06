import 'dart:developer';

import 'package:e_cource/feature/app_route/presentation/side_navigation_screen.dart';
import 'package:e_cource/feature/auth/presentation/view/login_screen.dart';
import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/presentation/view/cource_screen.dart';
import 'package:e_cource/feature/exam/presentation/view/add_final_exam_screen.dart';
import 'package:e_cource/feature/cource/presentation/view/course_details_screen.dart';
import 'package:e_cource/feature/dashboard/presentation/view/dashbpard_screen.dart';
import 'package:e_cource/feature/settings/presentation/view/main/settings_screen.dart';
import 'package:e_cource/feature/students/presentation/view/students_screen.dart';
import 'package:e_cource/feature/students/presentation/view/student_details_screen.dart';
import 'package:e_cource/general/core/services/go_route/go_router_refresh_stream_auth.dart';
import 'package:e_cource/general/core/services/go_route/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorkey = GlobalKey<NavigatorState>();

CustomTransitionPage<void> _customTransitionPage(
  Widget child,
  GoRouterState state,
) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

final router = GoRouter(
  navigatorKey: _rootNavigatorkey,
  initialLocation: RouteNames.loign,
  refreshListenable: GoRouterRefreshStreamAuth(
    FirebaseAuth.instance.authStateChanges(),
  ),

  redirect: (context, state) {
    log("redirect start");

    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLoginPage = state.matchedLocation == RouteNames.loign;

    if (!isLoggedIn && !isLoginPage) {
      return RouteNames.loign;
    }

    // logged in → block login page
    if (isLoggedIn && isLoginPage) {
      return RouteNames.dahsboard;
    }

    return null;
  },

  routes: [
    // OUTER shell
    GoRoute(
      path: RouteNames.loign,
      builder: (context, state) => const LoginScreen(),
    ),

    // main admin routes(shell bar)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return SideNavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.dahsboard,
              pageBuilder: (context, state) =>
                  _customTransitionPage(const DashboardScreen(), state),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.students,
              pageBuilder: (context, state) =>
                  _customTransitionPage(const StudentsScreen(), state),
              routes: [
                GoRoute(
                  path: 'details',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, String>?;
                    return _customTransitionPage(
                      StudentDetailsScreen(
                        studentData:
                            extra ??
                            {
                              'name': 'amal dev',
                              'phone': '+918590941583',
                              'email': '---',
                              'joinedAt': '25-06-2026',
                              'status': 'Enable',
                            },
                      ),
                      state,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.cources,
              pageBuilder: (context, state) =>
                  _customTransitionPage(const CourceScreen(), state),
              routes: [
                GoRoute(
                  path: 'details',
                  pageBuilder: (context, state) {
                    final course = state.extra as CourseModel;
                    return _customTransitionPage(
                      CourseDetailsScreen(course: course),
                      state,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'add-exam',
                      pageBuilder: (context, state) {
                        final extra =
                            state.extra as Map<String, String>;
                        return _customTransitionPage(
                          AddFinalExamScreen(
                            courseId: extra['courseId'] ?? '',
                            moduleId: extra['moduleId'] ?? '',
                            moduleName: extra['moduleName'] ?? '',
                          ),
                          state,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.settings,
              pageBuilder: (context, state) =>
                  _customTransitionPage(const SettingsScreen(), state),
            ),
          ],
        ),
      ],
    ),
  ],
);
