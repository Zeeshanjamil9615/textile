class TextileNewExporterItem {
  final int sr;
  final String exporter;
  final String country;
  final String productCategory;
  final String address;
  final String recordFound;

  TextileNewExporterItem({
    required this.sr,
    required this.exporter,
    required this.country,
    required this.productCategory,
    required this.address,
    required this.recordFound,
  });

  factory TextileNewExporterItem.fromJson(Map<String, dynamic> json) {
    return TextileNewExporterItem(
      sr: (json['sr'] is num)
          ? (json['sr'] as num).toInt()
          : int.tryParse(json['sr']?.toString() ?? '0') ?? 0,
      exporter: json['exporter']?.toString() ?? '',
      country: (json['country']?.toString() ?? '').trim(),
      productCategory: json['product_category']?.toString() ?? '',
      address: (json['address']?.toString() ?? '').trim(),
      recordFound: json['record_found']?.toString() ?? '',
    );
  }
}

