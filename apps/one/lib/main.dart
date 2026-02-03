import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_client/client/api_client.dart';
import 'package:logger/logger.dart';
import 'package:core/core.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 在启动时初始化 SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // 1. 注入 SharedPreferences 实例
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),

        // 2. 创建带文件日志的 Logger Provider
        loggerProvider.overrideWith((ref) {
          return Logger(
            printer: PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              lineLength: 80,
              colors: true,
              printEmojis: true,
            ),
            output: MultiOutput([
              ConsoleOutput(),
              AppFileOutput(
                maxFileSizeBytes: 5 * 1024 * 1024, // 5MB
                maxFileCount: 5,
                fileNamePrefix: 'app_log',
              ),
            ]),
          );
        }),

        // 3. 创建 ApiClient Provider (唯一定义处)
        apiClientProvider.overrideWith((ref) {
          final logger = ref.watch(loggerProvider);
          // tokenStorage 通过 tokenStorageProvider 自动创建
          final tokenStorage = ref.watch(tokenStorageProvider);

          const baseUrl = String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'http://192.168.1.245:8080',
          );

          return ApiClient(
            baseUrl: baseUrl,
            logger: logger,
            getAccessToken: () => tokenStorage.getAccessToken(),
          );
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'App One',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
