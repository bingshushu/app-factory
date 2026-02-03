import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/token_storage.dart';
import '../utils/result.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final AuthApi _authApi;
  final TokenStorage _tokenStorage;

  AuthRepository({
    required AuthApi authApi,
    required TokenStorage tokenStorage,
  })  : _authApi = authApi,
        _tokenStorage = tokenStorage;

  Future<Result<AuthResponse>> register({
    required String phone,
    String? password,
    String? verificationCode,
    String? nickname,
  }) async {
    try {
      final response = await _authApi.register(
        phone: phone,
        password: password,
        verificationCode: verificationCode,
        nickname: nickname,
      );

      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return Success(response);
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  Future<Result<AuthResponse>> login({
    required String phone,
    String? password,
    String? verificationCode,
  }) async {
    try {
      final response = await _authApi.login(
        phone: phone,
        password: password,
        verificationCode: verificationCode,
      );

      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return Success(response);
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  Future<Result<void>> sendVerificationCode({
    required String phone,
    required String type,
  }) async {
    try {
      await _authApi.sendVerificationCode(
        phone: phone,
        type: type,
      );
      return const Success(null);
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _authApi.logout();
      await _tokenStorage.clearTokens();
      return const Success(null);
    } on DioException catch (e) {
      // 即使请求失败，也清除本地 token
      await _tokenStorage.clearTokens();
      return Failure(_handleDioException(e));
    } catch (e) {
      await _tokenStorage.clearTokens();
      return Failure(UnknownException(e.toString()));
    }
  }

  Future<Result<User>> getCurrentUser() async {
    try {
      final user = await _authApi.getCurrentUser();
      return Success(user);
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  bool hasStoredTokens() {
    return _tokenStorage.hasTokens();
  }

  String? getAccessToken() {
    return _tokenStorage.getAccessToken();
  }

  AppException _handleDioException(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.message ?? 'Network error';

      if (statusCode == 401) {
        return AuthException('认证失败，请重新登录');
      } else if (statusCode == 400) {
        return ValidationException(message);
      } else {
        return NetworkException(message, statusCode: statusCode);
      }
    } else {
      return NetworkException('网络连接失败，请检查网络设置');
    }
  }
}

// SharedPreferences Provider - 需要在 main() 中通过 override 提供实例
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() with actual instance',
  );
}

// TokenStorage Provider - 同步创建
@riverpod
TokenStorage tokenStorage(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TokenStorage(prefs);
}

// ⚠️ ApiClient Provider 已移除
// 应该在应用层 (apps/*/main.dart) 通过 ProviderScope.overrides 创建
// 避免在共享包中定义具体的 Provider 实现

// AuthRepository Provider - 同步创建
@riverpod
AuthRepository authRepository(Ref ref) {
  final authApi = ref.watch(authApiProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);

  return AuthRepository(
    authApi: authApi,
    tokenStorage: tokenStorage,
  );
}
