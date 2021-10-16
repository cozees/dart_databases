part of 'database.dart';

class DatabaseException implements Exception {
  final dynamic message;

  const DatabaseException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return 'DatabaseException';
    return 'DatabaseException: $message';
  }
}