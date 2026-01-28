import 'package:textile/models/textile_importers_buyer_model.dart';

class TextileImportersResponse {
  final int status;
  final String message;
  final int totalRecords;
  final Map<String, dynamic> filtersApplied;
  final List<TextileImportersBuyerModel> data;

  TextileImportersResponse({
    required this.status,
    required this.message,
    required this.totalRecords,
    required this.filtersApplied,
    required this.data,
  });

  factory TextileImportersResponse.fromJson(Map<String, dynamic> json) {
    return TextileImportersResponse(
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      totalRecords: json['total_records'] as int? ?? 0,
      filtersApplied: json['filters_applied'] as Map<String, dynamic>? ?? {},
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => TextileImportersBuyerModel.fromJson(item as Map<String, dynamic>))
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
