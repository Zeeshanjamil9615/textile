class CountData {
  final int totalCount;
  final String type;

  CountData({required this.totalCount, required this.type});

  factory CountData.fromJson(Map<String, dynamic> json) {
    return CountData(
      totalCount: json['totalCount'] is num
          ? (json['totalCount'] as num).toInt()
          : int.tryParse(json['totalCount']?.toString() ?? '0') ?? 0,
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() =>
      {'totalCount': totalCount, 'type': type};
}

class CountResponse {
  final int status;
  final String message;
  final CountData? data;

  CountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CountResponse.fromJson(Map<String, dynamic> json) {
    return CountResponse(
      status: json['status'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? CountData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

