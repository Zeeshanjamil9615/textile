class ExporterModel {
  final String id;
  final String importerName;
  final String country;
  final String productCategory;
  final String ranking;
  final double buyersWorth;

  ExporterModel({
    required this.id,
    required this.importerName,
    required this.country,
    required this.productCategory,
    required this.ranking,
    required this.buyersWorth,
  });
}