import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class LoggerInterceptor extends Interceptor {
  static const String _logName = 'dio.interceptor';

  /// onRequestMethod
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '➡️ REQUEST [${options.method}] ${options.baseUrl}${options.path}',
      name: _logName,
    );
    developer.log('Headers: ${options.headers}', name: _logName);
    if (options.data != null) {
      developer.log('Body: ${options.data.toString()}', name: _logName);
    }
    handler.next(options);
  }

  /// onResponseMethod
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '✅ RESPONSE [${response.statusCode}] ${response.requestOptions.path}',
      name: _logName,
    );
    developer.log('Response: ${response.data}', name: _logName);
    developer.log('Headers: ${response.headers}', name: _logName);
    handler.next(response);
  }

  /// onErrorMethod
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ ERROR [${err.response?.statusCode}] ${err.requestOptions.path}',
      name: _logName,
      error: err,
    );
    developer.log(
      'Status: ${err.response?.statusMessage}, Data: ${err.response?.data}, Message: ${err.message}',
      name: _logName,
    );
    handler.next(err);
  }
}
