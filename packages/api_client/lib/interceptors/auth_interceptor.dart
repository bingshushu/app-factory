import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Logger logger;
  final String? Function() getAccessToken;

  AuthInterceptor({
    required this.dio,
    required this.logger,
    required this.getAccessToken,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      logger.w('Unauthorized request, token may be expired');
      // TODO: 实现 token 刷新逻辑
    }
    handler.next(err);
  }
}
