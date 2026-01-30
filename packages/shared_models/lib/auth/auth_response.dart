import 'package:freezed_annotation/freezed_annotation.dart';
import '../user/user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    required User user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
