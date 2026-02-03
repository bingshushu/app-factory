import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../interceptors/auth_interceptor.dart';

part 'api_client.g.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClient({
    required String baseUrl,
    required Logger logger,
    required String? Function() getAccessToken,
  })  : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )),
        _logger = logger {
    _dio.interceptors.add(AuthInterceptor(
      dio: _dio,
      logger: logger,
      getAccessToken: getAccessToken,
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => _logger.d(obj),
    ));
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('GET $path failed', error: e);
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('POST $path failed', error: e);
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('PUT $path failed', error: e);
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _logger.e('DELETE $path failed', error: e);
      rethrow;
    }
  }
}

@riverpod
Logger logger(Ref ref) {
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
      // 文件日志输出将在应用层通过 override 添加
    ]),
  );
}

// ApiClient Provider 声明
// ⚠️ 必须在应用层 (apps/*/main.dart) 通过 overrideWith 提供实际实现
@riverpod
ApiClient apiClient(Ref ref) {
  throw UnimplementedError(
    'apiClientProvider must be overridden in main() with actual implementation. '
    'See apps/*/lib/main.dart for example.',
  );
}
