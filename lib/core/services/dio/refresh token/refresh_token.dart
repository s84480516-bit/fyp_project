import 'package:dio/dio.dart';

class RefreshTokenAPI {
  // Dio private_instance
  final Dio _dio;

  // Constructor
  RefreshTokenAPI({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'Endpoints.baseURL'));

  // Refresh token api_endpoint
  Future<Response> refresh(String existingRefreshtoken) async {
    final response = await _dio.post(
      'Endpoints.refreshTokenUrl',
      data: {'refresh_token': existingRefreshtoken},
    );
    return response;
  }
}
