import 'package:textile/models/country_model.dart';

class CountriesResponse {
  final int status;
  final String message;
  final int totalRecords;
  final List<CountryModel> data;

  CountriesResponse({
    required this.status,
    required this.message,
    required this.totalRecords,
    required this.data,
  });

  factory CountriesResponse.fromJson(Map<String, dynamic> json) {
    return CountriesResponse(
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      totalRecords: json['total_records'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => CountryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'total_records': totalRecords,
      'data': data.map((country) => country.toJson()).toList(),
    };
  }
}
