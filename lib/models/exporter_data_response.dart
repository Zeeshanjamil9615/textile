class ExporterDataResponse {
  final String importer;
  final int totalRecords;
  final int totalProducts;
  final int totalCountries;
  final List<String> products;
  final List<String> countries;

  ExporterDataResponse({
    required this.importer,
    required this.totalRecords,
    required this.totalProducts,
    required this.totalCountries,
    required this.products,
    required this.countries,
  });

  factory ExporterDataResponse.fromJson(Map<String, dynamic> json) {
    final productsRaw = json['products'];
    final countriesRaw = json['countries'];

    List<String> toStringList(dynamic raw) {
      if (raw == null) return const [];
      if (raw is List) {
        return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
      }
      final text = raw.toString().trim();
      if (text.isEmpty) return const [];
      return text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return ExporterDataResponse(
      importer: (json['importer']?.toString() ?? '').trim(),
      totalRecords: (json['total_records'] is num)
          ? (json['total_records'] as num).toInt()
          : int.tryParse(json['total_records']?.toString() ?? '') ?? 0,
      totalProducts: (json['total_products'] is num)
          ? (json['total_products'] as num).toInt()
          : int.tryParse(json['total_products']?.toString() ?? '') ?? 0,
      totalCountries: (json['total_countries'] is num)
          ? (json['total_countries'] as num).toInt()
          : int.tryParse(json['total_countries']?.toString() ?? '') ?? 0,
      products: toStringList(productsRaw),
      countries: toStringList(countriesRaw),
    );
  }
}

