import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:textile/models/api_response.dart';
import 'package:textile/models/user_model.dart';
import 'package:textile/models/countries_response.dart';
import 'package:textile/models/product_categories_response.dart';
import 'package:textile/models/product_category_model.dart';
import 'package:textile/models/buyers_data_response.dart';
import 'package:textile/models/garment_socks_knitted_response.dart';
import 'package:textile/models/count_response.dart';
import 'package:textile/models/top_product_model.dart';
import 'package:textile/models/garment_denim_response.dart';
import 'package:textile/models/textile_importers_response.dart';
import 'package:textile/models/apnay_folders_response.dart';
import 'package:textile/models/folder_details_response.dart';
import 'package:textile/models/filtered_denim_list_response.dart';
import 'package:textile/models/textile_exporters_list_response.dart';
import 'package:textile/models/importers_city_wise_response.dart';
import 'package:textile/models/importers_country_wise_response.dart';
import 'package:textile/models/cyf_products_response.dart';
import 'package:textile/models/buyers_with_description_response.dart';
import 'package:textile/models/buyer_details_response.dart';
import 'package:textile/models/textile_new_exporters_response.dart';
import 'package:textile/models/seller_details_model.dart';
import 'package:textile/models/cities_list_response.dart';
import 'package:textile/models/exporter_city_wise_item.dart';
import 'package:textile/models/country_stats_response.dart';
import 'package:textile/models/exporter_city_seller_item.dart';
import 'package:textile/models/exporter_data_response.dart';

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

  // Get countries list API request
  Future<ApiResponse<List<String>>> getCountriesList() async {
    try {
      final response = await _dio.post('getCountriesList');

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the countries response
        final countriesResponse = CountriesResponse.fromJson(responseData);

        // Extract country names and add "All" at the beginning
        final countryNames = countriesResponse.data
            .map((country) => country.country)
            .toList();
        countryNames.insert(0, 'All');

        return ApiResponse<List<String>>(
          status: countriesResponse.status,
          message: countriesResponse.message,
          data: countryNames,
        );
      } else {
        return ApiResponse<List<String>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<List<String>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<String>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<void>> addOrUpdateBuyer({
    String? id,
    required String csId,
    required String csName,
    required String companyName,
    required String folderId,
    required String importerName,
    required String country,
    required String city,
    required String address,
    required String email,
    required String cell,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (id != null && id.trim().isNotEmpty) 'id': id.trim(),
        'cs_id': csId,
        'cs_name': csName,
        'company_name': companyName,
        'folder_id': folderId,
        'importer_name': importerName,
        'country': country,
        'city': city,
        'address': address,
        'email': email,
        'cell': cell,
        'latitude': latitude,
        'longitude': longitude,
      };

      final response = await _dio.post(
        'addOrUpdateBuyer',
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }

        return ApiResponse<void>.fromJson(responseData, null);
      }

      return ApiResponse<void>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map && (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ?? 'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<void>> forgotPassword({
    required String email,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
      });

      final response = await _dio.post(
        'forgotPassword',
        data: formData,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }

        return ApiResponse<void>.fromJson(responseData, null);
      }

      return ApiResponse<void>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map &&
            (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ??
              'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<List<CountryStatItem>>> getCountryStats() async {
    try {
      final response = await _dio.post('getCountryStats', data: '');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }

        final parsed = CountryStatsResponse.fromJson(responseData);
        return ApiResponse<List<CountryStatItem>>(
          status: parsed.status ? 200 : 0,
          message: parsed.status ? 'Success' : 'Failed to load country stats',
          data: parsed.data,
        );
      }

      return ApiResponse<List<CountryStatItem>>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map &&
            (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ??
              'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<List<CountryStatItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<CountryStatItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<void>> createFolder({
    required String csId,
    required String companyName,
    required String csFname,
    required String csLname,
    required String folderName,
    required String folderDesc,
    String image = 'image',
  }) async {
    try {
      final payload = {
        'cs_id': csId,
        'company_name': companyName,
        'csfname': csFname,
        'cslname': csLname,
        'foldername': folderName,
        'folderdesc': folderDesc,
        'image': image,
      };

      final response = await _dio.post(
        'createFolder',
        data: json.encode(payload),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }
        return ApiResponse<void>.fromJson(responseData, null);
      }

      return ApiResponse<void>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map &&
            (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ??
              'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<void>> deleteFolder({
    required String id,
  }) async {
    try {
      final response = await _dio.post(
        'deleteFolder',
        data: json.encode({'id': id}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }
        return ApiResponse<void>.fromJson(responseData, null);
      }

      return ApiResponse<void>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map &&
            (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ??
              'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<void>> deleteImporter({
    required String id,
  }) async {
    try {
      final response = await _dio.post(
        'deleteImporter',
        data: json.encode({'id': id}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }
        return ApiResponse<void>.fromJson(responseData, null);
      }

      return ApiResponse<void>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map &&
            (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ??
              'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<void>> addBuyerToFolder({
    required String userId,
    required String userName,
    required String userCompany,
    required String importerName,
    required String folderId,
    String product = '',
    String buyerType = '',
  }) async {
    try {
      final payload = {
        'user_id': userId,
        'user_name': userName,
        'user_company': userCompany,
        'importerName': importerName,
        'folder_id': folderId,
        'product': product,
        'buyer_type': buyerType,
      };

      final response = await _dio.post(
        'addBuyerToFolder',
        data: json.encode(payload),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }
        return ApiResponse<void>.fromJson(responseData, null);
      }

      return ApiResponse<void>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        if (e.response?.data is Map &&
            (e.response?.data as Map)['message'] != null) {
          errorMessage = (e.response?.data as Map)['message']?.toString() ??
              'Server error occurred';
        } else {
          errorMessage = 'Server error occurred';
        }
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request cancelled';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get product categories list with full models API request
  Future<ApiResponse<List<ProductCategoryModel>>> getProductCategoriesListWithIds() async {
    try {
      final response = await _dio.post('getPCTMasterList');

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the product categories response
        final categoriesResponse = ProductCategoriesResponse.fromJson(
          responseData,
        );

        return ApiResponse<List<ProductCategoryModel>>(
          status: categoriesResponse.status ? 200 : 0,
          message: 'Product categories retrieved successfully',
          data: categoriesResponse.data,
        );
      } else {
        return ApiResponse<List<ProductCategoryModel>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<List<ProductCategoryModel>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<ProductCategoryModel>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get product categories list API request
  Future<ApiResponse<List<String>>> getProductCategoriesList() async {
    try {
      final response = await _dio.post('getPCTMasterList');

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the product categories response
        final categoriesResponse = ProductCategoriesResponse.fromJson(
          responseData,
        );

        // Extract category names and add "All" at the beginning
        final categoryNames = categoriesResponse.data
            .map((category) => category.name)
            .toList();
        categoryNames.insert(0, 'All');

        return ApiResponse<List<String>>(
          status: categoriesResponse.status ? 200 : 0,
          message: 'Product categories retrieved successfully',
          data: categoryNames,
        );
      } else {
        return ApiResponse<List<String>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<List<String>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<String>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get all buyers data API request
  Future<ApiResponse<BuyersDataResponse>> getAllBuyersData({
    required String filterCountry,
    required String filterPct,
    required String filterBuyer,
  }) async {
    try {
      final formData = FormData.fromMap({
        'filter_country': filterCountry,
        'filter_pct': filterPct,
        'filter_buyer': filterBuyer,
      });

      final response = await _dio.post(
        'allBuyersData',
        data: formData,
      );

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the buyers data response
        final buyersResponse = BuyersDataResponse.fromJson(responseData);

        return ApiResponse<BuyersDataResponse>(
          status: buyersResponse.status,
          message: buyersResponse.message,
          data: buyersResponse,
        );
      } else {
        return ApiResponse<BuyersDataResponse>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<BuyersDataResponse>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<BuyersDataResponse>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get garment socks knitted data API request
  Future<ApiResponse<GarmentSocksKnittedResponse>> getGarmentSocksKnittedData({
    required String country,
    required String filterPct,
    required String filterBuyer,
  }) async {
    try {
      final formData = FormData.fromMap({
        'country': country,
        'filter_pct': filterPct,
        'filter_buyer': filterBuyer,
      });

      final response = await _dio.post(
        'garmentSocksKnitted',
        data: formData,
      );

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the garment socks knitted response
        final garmentResponse = GarmentSocksKnittedResponse.fromJson(responseData);

        return ApiResponse<GarmentSocksKnittedResponse>(
          status: garmentResponse.status,
          message: garmentResponse.message,
          data: garmentResponse,
        );
      } else {
        return ApiResponse<GarmentSocksKnittedResponse>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<GarmentSocksKnittedResponse>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<GarmentSocksKnittedResponse>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Dashboard: count textile importers
  Future<ApiResponse<CountData>> getTextileImportersCount() async {
    try {
      final response = await _dio.post('countTextileImporters');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final parsed = CountResponse.fromJson(responseData);
        return ApiResponse<CountData>(
          status: parsed.status,
          message: parsed.message,
          data: parsed.data,
        );
      } else {
        return ApiResponse<CountData>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<CountData>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<CountData>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Dashboard: count textile exporters
  Future<ApiResponse<CountData>> getTextileExportersCount() async {
    try {
      final response = await _dio.post('countTextileExporters');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final parsed = CountResponse.fromJson(responseData);
        return ApiResponse<CountData>(
          status: parsed.status,
          message: parsed.message,
          data: parsed.data,
        );
      } else {
        return ApiResponse<CountData>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<CountData>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<CountData>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Dashboard: top products
  Future<ApiResponse<List<TopProduct>>> getTopProducts() async {
    try {
      final response = await _dio.post('topProducts');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final parsed = TopProductsResponse.fromJson(responseData);
        return ApiResponse<List<TopProduct>>(
          status: parsed.status,
          message: parsed.message,
          data: parsed.data,
        );
      } else {
        return ApiResponse<List<TopProduct>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<List<TopProduct>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<TopProduct>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get all filtered denim data API request
  Future<ApiResponse<GarmentDenimResponse>> getAllFilteredDenimData({
    required String filterCountry,
    required String filterPct,
  }) async {
    try {
      final formData = FormData.fromMap({
        'filter_country': filterCountry,
        'filter_pct': filterPct,
      });

      final response = await _dio.post(
        'getAllFilteredDenimData',
        data: formData,
      );

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the garment denim response
        final denimResponse = GarmentDenimResponse.fromJson(responseData);

        return ApiResponse<GarmentDenimResponse>(
          status: denimResponse.status,
          message: denimResponse.message,
          data: denimResponse,
        );
      } else {
        return ApiResponse<GarmentDenimResponse>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<GarmentDenimResponse>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<GarmentDenimResponse>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Get all buyers data for textile importers
  Future<ApiResponse<TextileImportersResponse>> getAllImportersData({
    required String filterCountry,
    required String filterPct,
    required String filterBuyer,
  }) async {
    try {
      final formData = FormData.fromMap({
        'filter_country': filterCountry,
        'filter_pct': filterPct,
        'filter_buyer': filterBuyer,
      });

      final response = await _dio.post(
        'allBuyersData',
        data: formData,
      );

      if (response.statusCode == 200) {
        // Parse response data
        Map<String, dynamic> responseData;

        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        // Parse the textile importers response
        final importersResponse = TextileImportersResponse.fromJson(responseData);

        return ApiResponse<TextileImportersResponse>(
          status: importersResponse.status,
          message: importersResponse.message,
          data: importersResponse,
        );
      } else {
        return ApiResponse<TextileImportersResponse>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
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

      return ApiResponse<TextileImportersResponse>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<TextileImportersResponse>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get user's folders (apnayFolders). Pass cs_id from login as user_id.
  Future<ApiResponse<ApnayFoldersData>> getApnayFolders(String userId) async {
    try {
      final response = await _dio.post(
        'apnayFolders',
        data: json.encode({'user_id': userId}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataJson = responseData['data'] as Map<String, dynamic>?;
        if (dataJson == null) {
          return ApiResponse<ApnayFoldersData>(
            status: status,
            message: message,
          );
        }
        final data = ApnayFoldersData.fromJson(dataJson);
        return ApiResponse<ApnayFoldersData>(
          status: status,
          message: message,
          data: data,
        );
      } else {
        return ApiResponse<ApnayFoldersData>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<ApnayFoldersData>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<ApnayFoldersData>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get folder details (importers/buyers in folder). Pass cs_id as user_id, folder_id from folder list.
  Future<ApiResponse<List<FolderDetailItem>>> getFolderDetails(
    String userId,
    String folderId,
  ) async {
    try {
      final response = await _dio.post(
        'folderDetails',
        data: json.encode({
          'user_id': userId,
          'folder_id': folderId,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<FolderDetailItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => FolderDetailItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<FolderDetailItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<FolderDetailItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<FolderDetailItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<FolderDetailItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get filtered denim list by country. Pass cs_id from login and selected country name.
  Future<ApiResponse<List<FilteredDenimListItem>>> getFilteredDenimList(
    String csId,
    String filterCountry,
  ) async {
    try {
      final response = await _dio.post(
        'getFilteredDenimList',
        data: json.encode({
          'cs_id': csId,
          'filter_country': filterCountry,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<FilteredDenimListItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => FilteredDenimListItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<FilteredDenimListItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<FilteredDenimListItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<FilteredDenimListItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<FilteredDenimListItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get madeup records by country and product category. filter_country = selected country name, filter_pct = category id ("0" for All).
  Future<ApiResponse<List<FilteredDenimListItem>>> getMadeupRecords(
    String filterCountry,
    String filterPct,
  ) async {
    try {
      final response = await _dio.post(
        'getMadeupRecords',
        data: json.encode({
          'filter_country': filterCountry,
          'filter_pct': filterPct,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<FilteredDenimListItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => FilteredDenimListItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<FilteredDenimListItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<FilteredDenimListItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<FilteredDenimListItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<FilteredDenimListItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get textile exporters by country and product category. filter_country = selected country name, filter_pct = category id ("0" for All).
  Future<ApiResponse<List<TextileExporterItem>>> getTextileExporters(
    String filterCountry,
    String filterPct,
  ) async {
    try {
      final response = await _dio.post(
        'getTextileExporters',
        data: json.encode({
          'filter_country': filterCountry,
          'filter_pct': filterPct,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<TextileExporterItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => TextileExporterItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<TextileExporterItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<TextileExporterItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<TextileExporterItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<TextileExporterItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get importers city-wise list. POST with empty body.
  Future<ApiResponse<List<CityWiseItem>>> importersCityWise() async {
    try {
      final response = await _dio.post(
        'importersCityWise',
        data: null,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<CityWiseItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => CityWiseItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<CityWiseItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<CityWiseItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<CityWiseItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<CityWiseItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get exporters city-wise list. POST with empty body.
  Future<ApiResponse<List<ExporterCityItem>>> exporterCityWise() async {
    try {
      final response = await _dio.post(
        'exporterCityWise',
        data: null,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<ExporterCityItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => ExporterCityItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<ExporterCityItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<ExporterCityItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<ExporterCityItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<ExporterCityItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<List<ExporterCitySellerItem>>> exporterCityWiseS({
    required String city,
  }) async {
    try {
      final response = await _dio.post(
        'exporterCityWiseS',
        data: json.encode({'city': city}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] is int
            ? responseData['status'] as int
            : (responseData['status'] == true ? 200 : 0);
        final message = (responseData['message']?.toString() ?? '').trim();
        final dataList = responseData['data'];

        if (dataList is! List) {
          return ApiResponse<List<ExporterCitySellerItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }

        final sellers = <ExporterCitySellerItem>[];
        for (final entry in dataList) {
          if (entry is! Map) continue;
          final map = Map<String, dynamic>.from(entry as Map);
          final sellersList = map['sellers'];
          if (sellersList is! List) continue;
          for (final s in sellersList) {
            if (s is Map) {
              sellers.add(
                ExporterCitySellerItem.fromJson(
                  Map<String, dynamic>.from(s as Map),
                ),
              );
            }
          }
        }

        return ApiResponse<List<ExporterCitySellerItem>>(
          status: status,
          message: message,
          data: sellers,
        );
      }

      return ApiResponse<List<ExporterCitySellerItem>>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<List<ExporterCitySellerItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<ExporterCitySellerItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<ExporterDataResponse>> getExporterData({
    required String importer,
  }) async {
    try {
      final response = await _dio.post(
        'getExporterData',
        data: json.encode({'importer': importer}),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = Map<String, dynamic>.from(response.data as Map);
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'];
        final message = responseData['message']?.toString() ?? '';

        if (status == 200 || status == true) {
          return ApiResponse<ExporterDataResponse>(
            status: 200,
            message: message,
            data: ExporterDataResponse.fromJson(responseData),
          );
        }

        return ApiResponse<ExporterDataResponse>(
          status: 0,
          message: message.isNotEmpty ? message : 'Failed to load exporter data',
        );
      }

      return ApiResponse<ExporterDataResponse>(
        status: response.statusCode ?? 0,
        message: response.statusMessage ?? 'Unknown error',
      );
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return ApiResponse<ExporterDataResponse>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage.toString(),
      );
    } catch (e) {
      return ApiResponse<ExporterDataResponse>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get importers country-wise list. POST with empty body.
  Future<ApiResponse<List<CountryWiseItem>>> importersCountryWise() async {
    try {
      final response = await _dio.post(
        'importersCountryWise',
        data: null,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<CountryWiseItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => CountryWiseItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<CountryWiseItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<CountryWiseItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<CountryWiseItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<CountryWiseItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get CYF products by country and product category. filter_country = selected country name, filter_pct = category id ("0" for All).
  Future<ApiResponse<List<CyfProductItem>>> getCyfProducts(
    String filterPct,
    String filterCountry,
  ) async {
    try {
      final response = await _dio.post(
        'getCyfProducts',
        data: json.encode({
          'filter_pct': filterPct,
          'filter_country': filterCountry,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<CyfProductItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => CyfProductItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<CyfProductItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<CyfProductItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<CyfProductItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<CyfProductItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get buyers with description by country. POST FormData with filter_country.
  Future<ApiResponse<List<BuyerWithDescriptionItem>>> getBuyersWithDescription(
    String filterCountry,
  ) async {
    try {
      final formData = FormData.fromMap({
        'filter_country': filterCountry,
      });
      final response = await _dio.post(
        'getBuyersWithDescription',
        data: formData,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<BuyerWithDescriptionItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => BuyerWithDescriptionItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<BuyerWithDescriptionItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<BuyerWithDescriptionItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<BuyerWithDescriptionItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<BuyerWithDescriptionItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get buyer details by buyer name. POST JSON: buyer, importing (cs_id), blatlong.
  Future<ApiResponse<BuyerDetailsResponse>> getBuyerDetails({
    required String buyer,
    required String importing,
    String blatlong = '',
  }) async {
    try {
      final response = await _dio.post(
        'getBuyerDetails',
        data: json.encode({
          'buyer': buyer,
          'importing': "7xaz4",
          'blatlong': blatlong,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final details = BuyerDetailsResponse.fromJson(responseData);
        return ApiResponse<BuyerDetailsResponse>(
          status: status,
          message: message,
          data: details,
        );
      } else {
        return ApiResponse<BuyerDetailsResponse>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<BuyerDetailsResponse>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<BuyerDetailsResponse>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get new textile exporters list (for All Sellers screen).
  Future<ApiResponse<List<TextileNewExporterItem>>> getTextileNewExporters(
    String filterCountry,
    String filterPct,
  ) async {
    try {
      final response = await _dio.post(
        'getTextileNewExporters',
        data: json.encode({
          'filter_country': filterCountry,
          'filter_pct': filterPct,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<TextileNewExporterItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => TextileNewExporterItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<TextileNewExporterItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<TextileNewExporterItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<TextileNewExporterItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<TextileNewExporterItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get seller details for edit page.
  Future<ApiResponse<SellerDetails>> getSellerDetails({
    required String seller,
    required String exporting,
    String blatlong = '',
  }) async {
    try {
      final response = await _dio.post(
        'getSellerDetails',
        data: json.encode({
          'seller': seller,
          'exporting': '7xaz4',
          'blatlong': blatlong,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataJson = responseData['data'] as Map<String, dynamic>?;
        if (dataJson == null) {
          return ApiResponse<SellerDetails>(
            status: status,
            message: message,
          );
        }
        final details =
            SellerDetails.fromJson(Map<String, dynamic>.from(dataJson));
        return ApiResponse<SellerDetails>(
          status: status,
          message: message,
          data: details,
        );
      } else {
        return ApiResponse<SellerDetails>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<SellerDetails>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<SellerDetails>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Save / update seller info from edit page.
  Future<ApiResponse<void>> saveSellerInfo({
    required String rowId,
    required String importerName,
    required String address,
    required String email,
    required String city,
    required String country,
    required String contact,
    required String map,
    required String website,
    required String statusBar,
  }) async {
    try {
      final response = await _dio.post(
        'saveSellerInfo',
        data: json.encode({
          'row_id': rowId,
          'importer_name': importerName,
          'address': address,
          'email': email,
          'city': city,
          'country': country,
          'contact': contact,
          'map': map,
          'website': website,
          'status_bar': statusBar,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        return ApiResponse<void>(
          status: status,
          message: message,
        );
      } else {
        return ApiResponse<void>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<void>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<void>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get list of cities for seller edit dropdown.
  Future<ApiResponse<List<CityNameItem>>> getCitiesList() async {
    try {
      final response = await _dio.post(
        'getCitiesList',
        data: null,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;
        if (response.data is String) {
          responseData =
              json.decode(response.data as String) as Map<String, dynamic>;
        } else if (response.data is Map) {
          responseData = response.data as Map<String, dynamic>;
        } else {
          throw Exception('Unexpected response format');
        }

        final status = responseData['status'] as int? ?? 0;
        final message = responseData['message'] as String? ?? '';
        final dataList = responseData['data'];
        if (dataList is! List) {
          return ApiResponse<List<CityNameItem>>(
            status: status,
            message: message,
            data: const [],
          );
        }
        final list = (dataList as List)
            .map((e) => CityNameItem.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ))
            .toList();
        return ApiResponse<List<CityNameItem>>(
          status: status,
          message: message,
          data: list,
        );
      } else {
        return ApiResponse<List<CityNameItem>>(
          status: response.statusCode ?? 0,
          message: response.statusMessage ?? 'Unknown error',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }
      return ApiResponse<List<CityNameItem>>(
        status: e.response?.statusCode ?? 0,
        message: errorMessage,
      );
    } catch (e) {
      return ApiResponse<List<CityNameItem>>(
        status: 0,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
