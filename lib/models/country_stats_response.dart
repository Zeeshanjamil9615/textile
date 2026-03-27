class CountryStatItem {
  final String country;
  final String city;
  final int totalBuyers;
  final String status;
  final String firstId;
  final String lastId;

  CountryStatItem({
    required this.country,
    required this.city,
    required this.totalBuyers,
    required this.status,
    required this.firstId,
    required this.lastId,
  });

  factory CountryStatItem.fromJson(Map<String, dynamic> json) {
    return CountryStatItem(
      country: (json['country']?.toString() ?? '').trim(),
      city: (json['city']?.toString() ?? '').trim(),
      totalBuyers: (json['total_buyers'] is num)
          ? (json['total_buyers'] as num).toInt()
          : int.tryParse(json['total_buyers']?.toString() ?? '0') ?? 0,
      status: (json['status']?.toString() ?? '').trim(),
      firstId: (json['first_id']?.toString() ?? '').trim(),
      lastId: (json['last_id']?.toString() ?? '').trim(),
    );
  }
}

class CountryStatsResponse {
  final bool status;
  final int totalRecords;
  final List<CountryStatItem> data;

  CountryStatsResponse({
    required this.status,
    required this.totalRecords,
    required this.data,
  });

  factory CountryStatsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    return CountryStatsResponse(
      status: json['status'] == true,
      totalRecords: (json['total_records'] is num)
          ? (json['total_records'] as num).toInt()
          : int.tryParse(json['total_records']?.toString() ?? '0') ?? 0,
      data: rawList is List
          ? rawList
              .map((e) => CountryStatItem.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : const [],
    );
  }
}
