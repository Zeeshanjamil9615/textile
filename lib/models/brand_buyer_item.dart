class BrandBuyerItem {
  final String importer;
  final String country;

  BrandBuyerItem({
    required this.importer,
    required this.country,
  });

  factory BrandBuyerItem.fromJson(Map<String, dynamic> json) {
    return BrandBuyerItem(
      importer: (json['importer']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
    );
  }
}

