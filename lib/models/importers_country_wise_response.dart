/// Single item from importersCountryWise API.
class CountryWiseItem {
  final int id;
  final String city;
  final String country;
  final int noOfBuyerCountry;

  CountryWiseItem({
    required this.id,
    required this.city,
    required this.country,
    required this.noOfBuyerCountry,
  });

  factory CountryWiseItem.fromJson(Map<String, dynamic> json) {
    return CountryWiseItem(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      city: (json['city']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      noOfBuyerCountry: (json['no_of_buyer_country'] is num)
          ? (json['no_of_buyer_country'] as num).toInt()
          : int.tryParse(json['no_of_buyer_country']?.toString() ?? '0') ?? 0,
    );
  }
}
