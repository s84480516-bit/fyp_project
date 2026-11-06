import 'dart:io';
import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  final String errorMessage;

  DioExceptions.fromDioError(DioException dioError)
    : errorMessage = _mapError(dioError);

  static String _mapError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return 'Request to the server was cancelled.';
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out.';
      case DioExceptionType.receiveTimeout:
        return 'Request send timeout.';
      case DioExceptionType.badResponse:
        return dioError.response?.data?['detail']?.toString() ??
            'Server error.';
      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return 'No Internet Connection.';
        } else {
          return 'Unexpected error occurred.';
        }
      default:
        return 'Something went wrong.';
    }
  }

  @override
  String toString() => errorMessage;
}
