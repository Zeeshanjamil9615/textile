class BuyerModel {
  final int sr;
  final String productName;
  final String importerName;
  final String country;
  // Used only for filtering (matches web "product specification" radio selection)
  final String productCategory;

  BuyerModel({
    required this.sr,
    required this.productName,
    required this.importerName,
    required this.country,
    required this.productCategory,
  });
}