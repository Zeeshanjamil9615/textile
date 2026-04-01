class SellerDetails {
  final String id;
  final String importer;
  final String latlong;
  final String country;
  final String city;
  final String address;
  final String email;
  final String contactNumber;
  final String website;
  final String recordFound;

  // Extra fields from getSellerDetails response
  final String formattedTotalValue;
  final List<SellerBuyerItem> buyersList;
  final List<String> productCategories;
  final List<String> sellingCountries;
  final List<SellerTransactionItem> transactions;

  SellerDetails({
    required this.id,
    required this.importer,
    required this.latlong,
    required this.country,
    required this.city,
    required this.address,
    required this.email,
    required this.contactNumber,
    required this.website,
    required this.recordFound,
    this.formattedTotalValue = '',
    this.buyersList = const [],
    this.productCategories = const [],
    this.sellingCountries = const [],
    this.transactions = const [],
  });

  factory SellerDetails.fromJson(Map<String, dynamic> json) {
    // Support both old flat and new nested seller_info structure
    final sellerInfoRaw = json['seller_info'];
    final sellerInfo = sellerInfoRaw is Map<String, dynamic>
        ? sellerInfoRaw
        : json;

    final buyersRaw = json['buyers_list'];
    final productCategoriesRaw = json['product_categories'];
    final sellingCountriesRaw = json['selling_countries'];
    final txRaw = json['transactions'];

    return SellerDetails(
      id: sellerInfo['id']?.toString() ?? json['id']?.toString() ?? '',
      importer: sellerInfo['importer']?.toString() ?? json['importer']?.toString() ?? '',
      latlong: sellerInfo['latlong']?.toString() ?? json['latlong']?.toString() ?? '',
      country: sellerInfo['country']?.toString() ?? json['country']?.toString() ?? '',
      city: sellerInfo['city']?.toString() ?? json['city']?.toString() ?? '',
      address: sellerInfo['address']?.toString() ?? json['address']?.toString() ?? '',
      email: sellerInfo['email']?.toString() ?? json['email']?.toString() ?? '',
      contactNumber: sellerInfo['contact_number']?.toString() ??
          json['contact_number']?.toString() ??
          '',
      website: sellerInfo['website']?.toString() ?? json['website']?.toString() ?? '',
      recordFound: sellerInfo['record_found']?.toString() ??
          json['record_found']?.toString() ??
          '',
      formattedTotalValue: sellerInfo['formatted_total_value']?.toString() ??
          json['formatted_total_value']?.toString() ??
          '',
      buyersList: buyersRaw is List
          ? buyersRaw
              .whereType<Map>()
              .map((e) => SellerBuyerItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      productCategories: productCategoriesRaw is List
          ? productCategoriesRaw
              .map((e) => (e is Map ? e['category_name']?.toString() : e?.toString()) ?? '')
              .where((e) => e.trim().isNotEmpty)
              .map((e) => e.trim())
              .toList()
          : const [],
      sellingCountries: sellingCountriesRaw is List
          ? sellingCountriesRaw
              .map((e) => e?.toString() ?? '')
              .where((e) => e.trim().isNotEmpty)
              .map((e) => e.trim())
              .toList()
          : const [],
      transactions: txRaw is List
          ? txRaw
              .whereType<Map>()
              .map((e) => SellerTransactionItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

class SellerBuyerItem {
  final String importer;
  final String country;
  final String productCategory;
  final String pctCode;

  SellerBuyerItem({
    required this.importer,
    required this.country,
    required this.productCategory,
    required this.pctCode,
  });

  factory SellerBuyerItem.fromJson(Map<String, dynamic> json) {
    return SellerBuyerItem(
      importer: (json['importer']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      productCategory: (json['product_category']?.toString() ?? '').trim(),
      pctCode: (json['pct_code']?.toString() ?? '').trim(),
    );
  }
}

class SellerTransactionItem {
  final String id;
  final String date;
  final String importer;
  final String country;
  final String description;
  final String unitPrice;
  final String quantity;
  final String valueFc;
  final String pctCode;

  SellerTransactionItem({
    required this.id,
    required this.date,
    required this.importer,
    required this.country,
    required this.description,
    required this.unitPrice,
    required this.quantity,
    required this.valueFc,
    required this.pctCode,
  });

  factory SellerTransactionItem.fromJson(Map<String, dynamic> json) {
    return SellerTransactionItem(
      id: (json['id']?.toString() ?? '').trim(),
      date: (json['date']?.toString() ?? '').trim(),
      importer: (json['importer']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      description: (json['description']?.toString() ?? '').trim(),
      unitPrice: (json['unit_price']?.toString() ?? '').trim(),
      quantity: (json['quantity']?.toString() ?? '').trim(),
      valueFc: (json['value_fc']?.toString() ?? '').trim(),
      pctCode: (json['pct_code']?.toString() ?? '').trim(),
    );
  }
}


