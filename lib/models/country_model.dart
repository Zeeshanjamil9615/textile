class CountryModel {
  final String country;

  CountryModel({required this.country});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(country: json['country']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'country': country};
  }
}
