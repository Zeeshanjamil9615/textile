class CountryModel {
  final String country;
  final int totalRecords;
  final String isoCode;
  final String flagUrl;
  final String region;

  CountryModel({
    required this.country,
    this.totalRecords = 0,
    this.isoCode = '',
    this.flagUrl = '',
    this.region = '',
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final rawCountry = json['country']?.toString() ?? '';
    final normalizedCountry = rawCountry
        .replaceAll(RegExp(r'[\r\n]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final rawRegion = json['region']?.toString() ?? '';
    final normalizedRegion = rawRegion
        .replaceAll(RegExp(r'[\r\n]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return CountryModel(
      country: normalizedCountry,
      totalRecords: int.tryParse(json['total_records']?.toString() ?? '') ?? 0,
      isoCode: json['iso_code']?.toString().trim() ?? '',
      flagUrl: json['flag']?.toString().trim() ?? '',
      region: normalizedRegion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'total_records': totalRecords,
      'iso_code': isoCode,
      'flag': flagUrl,
      'region': region,
    };
  }
}
