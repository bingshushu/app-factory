import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/auth/auth_state.dart';
import 'package:auth_ui/auth_ui.dart';
import '../../features/home/home_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  // 创建一个 notifier 用于触发路由刷新
  final notifier = ValueNotifier<int>(0);

  // 监听 authState 变化，触发路由刷新
  ref.listen(authStateProvider, (_, __) {
    notifier.value++;
  });

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier, // 添加刷新监听
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');

      // 如果未登录且不在认证页面，跳转到登录页
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // 如果已登录且在认证页面，跳转到首页
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
    ],
  );
}
