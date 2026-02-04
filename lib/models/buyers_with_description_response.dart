/// Single item from getBuyersWithDescription API.
class BuyerWithDescriptionItem {
  final int id;
  final String importer;
  final String country;
  final String description;

  BuyerWithDescriptionItem({
    required this.id,
    required this.importer,
    required this.country,
    required this.description,
  });

  factory BuyerWithDescriptionItem.fromJson(Map<String, dynamic> json) {
    return BuyerWithDescriptionItem(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      importer: (json['importer']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      description: (json['description_cleaned']?.toString() ?? json['description']?.toString() ?? '').trim(),
    );
  }
}
