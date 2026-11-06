import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../refresh token/refresh_token.dart';
import '../../local storage/local_storage_service.dart';

class AuthorizationInterceptor extends Interceptor {
  // LocalStorageInstance - for getting the saved access & refresh tokens.
  final LocalStorageService localStorageService = LocalStorageService();

  /// onRequestMethod - attaching Authorization header if access token exists.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (options.data is! FormData) {
        options.headers['Content-Type'] = 'application/json';
      }

      // Skipping if request does not require auth
      if (options.extra['requiresAuth'] == false) {
        return handler.next(options);
      }

      // Getting access, refresh token, expiry time and selected_language_code from the local storage
      final accessToken = 'await localStorageService.getAccessToken()';
      final refreshToken = 'await localStorageService.getRefreshToken()';
      final expiryTimeStr = 'await localStorageService.getExpiryTime()';
      debugPrint(accessToken);

      // Checking the access token status
      final expiryTime = DateTime.tryParse(expiryTimeStr);
      final now = DateTime.now();
      // Only refreshing: if token is about to expire (within 1 hour) or already expired
      if (expiryTime != null &&
          now.isAfter(expiryTime.subtract(Duration(hours: 1)))) {
        if (refreshToken.isNotEmpty) {
          try {
            final refreshApi = RefreshTokenAPI();
            final response = await refreshApi.refresh(refreshToken);

            final data = response.data;
            final newAccess = data['access_token'];
            final newRefresh = data['refresh_token'];

            if (newAccess != null) {
              //await localStorageService.saveAccessToken(newAccess.toString());
              if (newRefresh != null) {
                // await localStorageService.saveRefreshToken(newRefresh.toString());
              }
              // await localStorageService.saveExpiryTime(
              //     DateTime.now().add(Duration(hours: 10)).toIso8601String());
            } else {
              // await localStorageService.clearTokens();
            }
          } catch (_) {
            //await localStorageService.clearTokens();
          }
        }
      }

      // Attaching latest tokens
      final updatedAccessToken = 'await localStorageService.getAccessToken()';
      if (updatedAccessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $updatedAccessToken';
      }
      handler.next(options);
    } catch (_) {
      handler.next(options);
    }
  }

  /// onErrorMethod - solving the expire token issue
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Fallback: if API returns 401 → try refresh
    if (err.response?.statusCode == 401) {
      final refreshToken = 'await localStorageService.getRefreshToken()';
      if (refreshToken.isEmpty) {
        // await localStorageService.clearTokens();
        return handler.next(err);
      }

      try {
        final refreshApi = RefreshTokenAPI();
        final response = await refreshApi.refresh(refreshToken);

        final data = response.data;
        final newAccess = data['access_token'];
        final newRefresh = data['refresh_token'];

        if (newAccess != null) {
          // await localStorageService.saveAccessToken(newAccess.toString());
          if (newRefresh != null) {
            // await localStorageService.saveRefreshToken(newRefresh.toString());
          }
          // await localStorageService.saveExpiryTime(
          //   DateTime.now().add(const Duration(hours: 10)).toIso8601String(),
          // );

          // Retry original request
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
          final dio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl));
          final response2 = await dio.fetch(err.requestOptions);
          return handler.resolve(response2);
        } else {
          // await localStorageService.clearTokens();
        }
      } catch (_) {
        // await localStorageService.clearTokens();
      }
    }

    return handler.next(err);
  }
}
