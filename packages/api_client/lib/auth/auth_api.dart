import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_models/shared_models.dart';
import '../client/api_client.dart';

part 'auth_api.g.dart';

class AuthApi {
  final ApiClient _client;

  AuthApi(this._client);

  Future<AuthResponse> register({
    required String phone,
    String? password,
    String? verificationCode,
    String? nickname,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/register',
      data: {
        'phone': phone,
        if (password != null) 'password': password,
        if (verificationCode != null) 'verificationCode': verificationCode,
        if (nickname != null) 'nickname': nickname,
      },
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );

    if (apiResponse.code != 0) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.message,
      );
    }

    return AuthResponse.fromJson(apiResponse.data!);
  }

  Future<AuthResponse> login({
    required String phone,
    String? password,
    String? verificationCode,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/login',
      data: {
        'phone': phone,
        if (password != null) 'password': password,
        if (verificationCode != null) 'verificationCode': verificationCode,
      },
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );

    if (apiResponse.code != 0) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.message,
      );
    }

    return AuthResponse.fromJson(apiResponse.data!);
  }

  Future<void> sendVerificationCode({
    required String phone,
    required String type,
  }) async {
    final response = await _client.post(
      '/api/v1/auth/send-code',
      data: {
        'phone': phone,
        'type': type,
      },
    );

    final apiResponse = ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (json) {},
    );

    if (apiResponse.code != 0) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.message,
      );
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _client.post(
      '/api/v1/auth/refresh',
      data: {
        'refreshToken': refreshToken,
      },
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );

    if (apiResponse.code != 0) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.message,
      );
    }

    return AuthResponse.fromJson(apiResponse.data!);
  }

  Future<void> logout() async {
    final response = await _client.post('/api/v1/auth/logout');

    final apiResponse = ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (json) {},
    );

    if (apiResponse.code != 0) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.message,
      );
    }
  }

  Future<User> getCurrentUser() async {
    final response = await _client.get('/api/v1/auth/me');

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );

    if (apiResponse.code != 0) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: apiResponse.message,
      );
    }

    return User.fromJson(apiResponse.data!);
  }
}

@riverpod
AuthApi authApi(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return AuthApi(client);
}
