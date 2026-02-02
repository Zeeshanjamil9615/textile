/// Single item from importersCityWise API.
class CityWiseItem {
  final int id;
  final String city;
  final String country;
  final int noOfBuyerCity;

  CityWiseItem({
    required this.id,
    required this.city,
    required this.country,
    required this.noOfBuyerCity,
  });

  factory CityWiseItem.fromJson(Map<String, dynamic> json) {
    return CityWiseItem(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      city: (json['city']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      noOfBuyerCity: (json['no_of_buyer_city'] is num)
          ? (json['no_of_buyer_city'] as num).toInt()
          : int.tryParse(json['no_of_buyer_city']?.toString() ?? '0') ?? 0,
    );
  }
}
