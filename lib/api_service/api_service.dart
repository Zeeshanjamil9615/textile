import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:textile/models/api_response.dart';
import 'package:textile/models/user_model.dart';

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'https://textileanalytics.pk/api/';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
    );

    // Add interceptors for logging (optional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  // Login API request
  Future<ApiResponse<UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final formData = FormData.fromMap({
        'txtusername': username,
        'txtpassword': password,
      });

      final response = await _dio.post(
        'loginRequest',
        data: formData,
        options: Options(
          headers: {'Cookie': 'PHPSESSID=jh78i0u3r2mi6hbfldre6f8h02'},
        ),
      );

      if (response.statusCode == 200) {
        // Parse response data - handle both string and object responses
        Map<String, dynamic> responseData;

        if (response.data is String) {
          // If response is a string, parse it as JSON
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          // If response is already a Map, use it directly
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Create API response
        final apiResponse = ApiResponse<UserModel>.fromJson(
          responseData,
          (data) => UserModel.fromJson(data as Map<String, dynamic>),
        );
        return apiResponse;
      } else {
        return ApiResponse<UserModel>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      String errorMessage = 'Network error occurred';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<UserModel>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      // Handle other errors
      return ApiResponse<UserModel>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Add more API methods here as needed
  // Example:
  // Future<ApiResponse<SomeModel>> getSomeData() async { ... }
}
