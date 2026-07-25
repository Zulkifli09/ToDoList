import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_flow/domain/models/task_model.dart';
import 'package:task_flow/features/home/presentation/pages/home_page.dart';
import 'package:task_flow/features/home/presentation/pages/main_layout.dart';
import 'package:task_flow/features/task/presentation/pages/task_form_page.dart';
import 'package:task_flow/features/task/presentation/pages/task_detail_page.dart';
import 'package:task_flow/features/task/presentation/pages/calendar_page.dart';
import 'package:task_flow/features/statistics/presentation/pages/statistics_page.dart';
import 'package:task_flow/features/settings/presentation/pages/settings_page.dart';
import 'package:animations/animations.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/task/create',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const TaskFormPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/task/edit/:id',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final task = state.extra as TaskModel?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: TaskFormPage(existingTask: task),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/task/detail/:id',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final task = state.extra as TaskModel;
        return CustomTransitionPage(
          key: state.pageKey,
          child: TaskDetailPage(task: task),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      },
    ),
  ],
);
