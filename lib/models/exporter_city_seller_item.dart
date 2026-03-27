class ExporterCitySellerItem {
  final String id;
  final String importer;
  final String city;
  final String address;
  final String email;
  final String contactNumber;
  final String website;
  final String country;
  final List<String> categories;
  final List<String> exporterCountries;

  ExporterCitySellerItem({
    required this.id,
    required this.importer,
    required this.city,
    required this.address,
    required this.email,
    required this.contactNumber,
    required this.website,
    required this.country,
    required this.categories,
    required this.exporterCountries,
  });

  static List<String> _toList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    final text = value.toString().trim();
    if (text.isEmpty) return const [];
    return text
        .split(RegExp(r'[\n,|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  factory ExporterCitySellerItem.fromJson(Map<String, dynamic> json) {
    final categories = _toList(
      json['product_categories'] ??
          json['product_category'] ??
          json['categories'] ??
          json['category'] ??
          json['pct'],
    );
    final countries = _toList(
      json['exporter_countries'] ??
          json['countries'] ??
          json['country_list'] ??
          json['export_countries'] ??
          json['country'],
    );

    return ExporterCitySellerItem(
      id: (json['id']?.toString() ?? '').trim(),
      importer: (json['importer']?.toString() ?? '').trim(),
      city: (json['city']?.toString() ?? '').trim(),
      address: (json['address']?.toString() ?? '').trim(),
      email: (json['email']?.toString() ?? '').trim(),
      contactNumber: (json['contact_number']?.toString() ?? '').trim(),
      website: (json['website']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      categories: categories,
      exporterCountries: countries,
    );
  }
}
