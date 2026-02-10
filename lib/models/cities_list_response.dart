class CityNameItem {
  final String city;

  CityNameItem({required this.city});

  factory CityNameItem.fromJson(Map<String, dynamic> json) {
    return CityNameItem(
      city: json['city']?.toString() ?? '',
    );
  }
}

