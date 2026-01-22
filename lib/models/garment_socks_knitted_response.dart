import 'package:textile/models/garment_socks_knitted_data_model.dart';

class GarmentSocksKnittedResponse {
  final int status;
  final String message;
  final int totalRecords;
  final List<GarmentSocksKnittedDataModel> data;

  GarmentSocksKnittedResponse({
    required this.status,
    required this.message,
    required this.totalRecords,
    required this.data,
  });

  factory GarmentSocksKnittedResponse.fromJson(Map<String, dynamic> json) {
    return GarmentSocksKnittedResponse(
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      totalRecords: json['total_records'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => GarmentSocksKnittedDataModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'total_records': totalRecords,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

