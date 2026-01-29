import 'package:textile/models/buyer_data_model.dart';

class BuyersDataResponse {
  final int status;
  final String message;
  final Map<String, dynamic> filtersApplied;
  final int totalRecords;
  final List<BuyerDataModel> data;

  BuyersDataResponse({
    required this.status,
    required this.message,
    required this.filtersApplied,
    required this.totalRecords,
    required this.data,
  });

  factory BuyersDataResponse.fromJson(Map<String, dynamic> json) {
    return BuyersDataResponse(
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      filtersApplied: json['filters_applied'] as Map<String, dynamic>? ?? {},
      totalRecords: json['total_records'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => BuyerDataModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'filters_applied': filtersApplied,
      'total_records': totalRecords,
      'data': data.map((buyer) => buyer.toJson()).toList(),
    };
  }
}



