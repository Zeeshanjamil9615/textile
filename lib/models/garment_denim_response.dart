import 'package:textile/models/garment_denim_data_model.dart';

class GarmentDenimResponse {
  final int status;
  final String message;
  final int totalRecords;
  final Map<String, dynamic> filtersApplied;
  final List<GarmentDenimDataModel> data;

  GarmentDenimResponse({
    required this.status,
    required this.message,
    required this.totalRecords,
    required this.filtersApplied,
    required this.data,
  });

  factory GarmentDenimResponse.fromJson(Map<String, dynamic> json) {
    return GarmentDenimResponse(
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      totalRecords: json['total_records'] as int? ?? 0,
      filtersApplied: json['filters_applied'] as Map<String, dynamic>? ?? {},
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => GarmentDenimDataModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'total_records': totalRecords,
      'filters_applied': filtersApplied,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
