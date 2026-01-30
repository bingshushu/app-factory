import 'package:shared_models/shared_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  User? build() {
    // 初始状态为 null，表示未登录
    return null;
  }

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  bool get isAuthenticated => state != null;
}
