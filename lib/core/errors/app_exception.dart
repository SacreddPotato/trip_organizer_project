sealed class AppException implements Exception {
  const AppException(this.userMessage);
  final String userMessage;
}

final class AuthException extends AppException {
  const AuthException(super.userMessage);
}

final class NetworkException extends AppException {
  const NetworkException() : super('No internet connection. Please try again.');
}

final class UnknownException extends AppException {
  const UnknownException() : super('Something went wrong. Please try again.');
}
