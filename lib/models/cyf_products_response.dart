/// Single item from getCyfProducts API.
class CyfProductItem {
  final int sr;
  final String productName;
  final String exporter;
  final String? importerCity;
  final String country;

  CyfProductItem({
    required this.sr,
    required this.productName,
    required this.exporter,
    this.importerCity,
    required this.country,
  });

  factory CyfProductItem.fromJson(Map<String, dynamic> json) {
    return CyfProductItem(
      sr: (json['sr'] is num)
          ? (json['sr'] as num).toInt()
          : int.tryParse(json['sr']?.toString() ?? '0') ?? 0,
      productName: (json['product_name']?.toString() ?? '').trim(),
      exporter: (json['exporter']?.toString() ?? '').trim(),
      importerCity: json['importer_city']?.toString()?.trim(),
      country: (json['country']?.toString() ?? '').trim(),
    );
  }
}
