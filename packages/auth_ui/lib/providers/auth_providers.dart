import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/auth/auth_repository.dart';
import 'package:core/auth/auth_state.dart';
import 'package:core/utils/result.dart';

part 'auth_providers.g.dart';

/// 登录 Provider
@riverpod
class Login extends _$Login {
  @override
  FutureOr<void> build() {}

  Future<Result<void>> loginWithPassword({
    required String phone,
    required String password,
  }) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.login(
      phone: phone,
      password: password,
    );

    return result.when(
      success: (authResponse) {
        if (!ref.mounted) return const Success(null);
        ref.read(authStateProvider.notifier).setUser(authResponse.user);
        state = const AsyncData(null);
        return const Success(null);
      },
      failure: (error) {
        if (!ref.mounted) return Failure(error);
        state = AsyncError(error, StackTrace.current);
        return Failure(error);
      },
    );
  }

  Future<Result<void>> loginWithCode({
    required String phone,
    required String code,
  }) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.login(
      phone: phone,
      verificationCode: code,
    );

    return result.when(
      success: (authResponse) {
        if (!ref.mounted) return const Success(null);
        ref.read(authStateProvider.notifier).setUser(authResponse.user);
        state = const AsyncData(null);
        return const Success(null);
      },
      failure: (error) {
        if (!ref.mounted) return Failure(error);
        state = AsyncError(error, StackTrace.current);
        return Failure(error);
      },
    );
  }
}

/// 注册 Provider
@riverpod
class Register extends _$Register {
  @override
  FutureOr<void> build() {}

  Future<Result<void>> registerWithPassword({
    required String phone,
    required String password,
    String? nickname,
  }) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.register(
      phone: phone,
      password: password,
      nickname: nickname,
    );

    return result.when(
      success: (authResponse) {
        if (!ref.mounted) return const Success(null);
        ref.read(authStateProvider.notifier).setUser(authResponse.user);
        state = const AsyncData(null);
        return const Success(null);
      },
      failure: (error) {
        if (!ref.mounted) return Failure(error);
        state = AsyncError(error, StackTrace.current);
        return Failure(error);
      },
    );
  }

  Future<Result<void>> registerWithCode({
    required String phone,
    required String code,
    String? nickname,
  }) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.register(
      phone: phone,
      verificationCode: code,
      nickname: nickname,
    );

    return result.when(
      success: (authResponse) {
        if (!ref.mounted) return const Success(null);
        ref.read(authStateProvider.notifier).setUser(authResponse.user);
        state = const AsyncData(null);
        return const Success(null);
      },
      failure: (error) {
        if (!ref.mounted) return Failure(error);
        state = AsyncError(error, StackTrace.current);
        return Failure(error);
      },
    );
  }
}

/// 发送验证码 Provider
@riverpod
class SendVerificationCode extends _$SendVerificationCode {
  @override
  FutureOr<void> build() {}

  Future<Result<void>> send({
    required String phone,
    required String type,
  }) async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.sendVerificationCode(
      phone: phone,
      type: type,
    );

    return result.when(
      success: (_) {
        if (!ref.mounted) return const Success(null);
        state = const AsyncData(null);
        return const Success(null);
      },
      failure: (error) {
        if (!ref.mounted) return Failure(error);
        state = AsyncError(error, StackTrace.current);
        return Failure(error);
      },
    );
  }
}

/// 登出 Provider
@riverpod
class Logout extends _$Logout {
  @override
  FutureOr<void> build() {}

  Future<Result<void>> logout() async {
    state = const AsyncLoading();

    final authRepo = ref.read(authRepositoryProvider);
    final result = await authRepo.logout();

    return result.when(
      success: (_) {
        if (!ref.mounted) return const Success(null);
        ref.read(authStateProvider.notifier).clearUser();
        state = const AsyncData(null);
        return const Success(null);
      },
      failure: (error) {
        if (!ref.mounted) return Failure(error);
        // 即使失败也清除本地状态
        ref.read(authStateProvider.notifier).clearUser();
        state = AsyncError(error, StackTrace.current);
        return Failure(error);
      },
    );
  }
}

// Result 扩展方法
extension ResultExtension<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure(error: final error) => failure(error),
    };
  }
}
