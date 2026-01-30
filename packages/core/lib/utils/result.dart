sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException error;
  const Failure(this.error);
}

sealed class AppException implements Exception {
  String get message;
}

class NetworkException extends AppException {
  @override
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message (status: $statusCode)';
}

class AuthException extends AppException {
  @override
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException extends AppException {
  @override
  final String message;
  final Map<String, String>? errors;

  ValidationException(this.message, {this.errors});

  @override
  String toString() => 'ValidationException: $message';
}

class UnknownException extends AppException {
  @override
  final String message;

  UnknownException(this.message);

  @override
  String toString() => 'UnknownException: $message';
}
