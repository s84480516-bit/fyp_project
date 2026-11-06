import 'dart:convert';
import 'endpoints.dart';
import 'dio_exceptions.dart';
import 'package:dio/dio.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/authorization_interceptor.dart';
import 'package:cleanarchitecturetemplate/core/constants/app_constants.dart';

class DioClient {
  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: Endpoints.baseURL,
          connectTimeout: Duration(seconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(seconds: AppConstants.receiveTimeout),
          responseType: ResponseType.json,
          headers: {
            'User-Agent': 'ScanEthAI - Android - Version 1.0 (support@scaneth.ai)',
            'Accept': 'application/json',
          },
        ),
      )..interceptors.addAll([AuthorizationInterceptor(), LoggerInterceptor()]);

  late final Dio _dio;
  final CancelToken _cancelToken = CancelToken();

  /// Request: generic method for GET/POST/PUT/DELETE, supports decoder and upload progress.
  Future<Response> request<T>({
    required String method,
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    T Function(dynamic data)? decoder,
    Function(double)? onProgress,
    bool? requiredAuth,
  }) async {
    try {
      final options = Options(
        method: method,
        headers: headers,
        extra: {'requiresAuth': requiredAuth},
      );
      final response = await _dio.request(
        url,
        queryParameters: queryParams,
        data: body == null
            ? null
            : (body is FormData ? body : jsonEncode(body)),
        options: options,
        cancelToken: _cancelToken,
        onSendProgress: onProgress != null
            ? (sent, total) {
                if (total > 0) {
                  double progress = (sent / total) * 100;
                  onProgress(progress);
                }
              }
            : null,
      );
      return response;
    } on DioException catch (err) {
      throw DioExceptions.fromDioError(err);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
