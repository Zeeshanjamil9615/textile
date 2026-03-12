/// Single item from exporterCityWise API.
class ExporterCityItem {
  final int id;
  final String city;
  final String country;
  final int noOfSellersCity;

  ExporterCityItem({
    required this.id,
    required this.city,
    required this.country,
    required this.noOfSellersCity,
  });

  factory ExporterCityItem.fromJson(Map<String, dynamic> json) {
    return ExporterCityItem(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      city: (json['city']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      noOfSellersCity: (json['no_of_sellers_city'] is num)
          ? (json['no_of_sellers_city'] as num).toInt()
          : int.tryParse(json['no_of_sellers_city']?.toString() ?? '0') ?? 0,
    );
  }
}

