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
  );
}

@riverpod
ApiClient apiClient(Ref ref) {
  final logger = ref.watch(loggerProvider);

  // TODO: 从环境变量或配置中读取 baseUrl
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.245:8081',
  );

  // getAccessToken 将在 core 包中通过 override 提供
  return ApiClient(
    baseUrl: baseUrl,
    logger: logger,
    getAccessToken: () => null, // 默认返回 null，需要在 core 中 override
  );
}
