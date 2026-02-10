/// Buyer profile from getBuyerDetails API.
class BuyerProfile {
  final String name;
  final String address;
  final String email;
  final String contact;
  final String city;
  final String country;
  final String latlong;

  BuyerProfile({
    required this.name,
    required this.address,
    required this.email,
    required this.contact,
    required this.city,
    required this.country,
    required this.latlong,
  });

  factory BuyerProfile.fromJson(Map<String, dynamic> json) {
    return BuyerProfile(
      name: (json['name']?.toString() ?? '').trim(),
      address: (json['address']?.toString() ?? '').trim().replaceAll('&nbsp;', ' '),
      email: (json['email']?.toString() ?? '').trim(),
      contact: (json['contact']?.toString() ?? '').trim(),
      city: (json['city']?.toString() ?? '').trim(),
      country: (json['country']?.toString() ?? '').trim(),
      latlong: (json['latlong']?.toString() ?? '').trim(),
    );
  }
}

/// Buyer worth from getBuyerDetails API.
class BuyerWorth {
  final String currency;
  final double totalFc;

  BuyerWorth({
    required this.currency,
    required this.totalFc,
  });

  factory BuyerWorth.fromJson(Map<String, dynamic> json) {
    return BuyerWorth(
      currency: (json['currency']?.toString() ?? 'USD').trim(),
      totalFc: (json['total_fc'] is num)
          ? (json['total_fc'] as num).toDouble()
          : double.tryParse(json['total_fc']?.toString() ?? '0') ?? 0,
    );
  }
}

/// Single transaction from getBuyerDetails API.
class BuyerTransactionItem {
  final String id;
  final String date;
  final String exporter;
  final String pct;
  final String description;
  final String qty;
  final String unitPrice;
  final String valueFc;

  BuyerTransactionItem({
    required this.id,
    required this.date,
    required this.exporter,
    required this.pct,
    required this.description,
    required this.qty,
    required this.unitPrice,
    required this.valueFc,
  });

  factory BuyerTransactionItem.fromJson(Map<String, dynamic> json) {
    return BuyerTransactionItem(
      id: (json['id']?.toString() ?? '').trim(),
      date: (json['date']?.toString() ?? '').trim(),
      exporter: (json['exporter']?.toString() ?? '').trim(),
      pct: (json['pct']?.toString() ?? '').trim(),
      description: (json['description']?.toString() ?? '').trim(),
      qty: (json['qty']?.toString() ?? '').trim(),
      unitPrice: (json['unit_price']?.toString() ?? '').trim(),
      valueFc: (json['value_fc']?.toString() ?? '').trim(),
    );
  }
}

/// Full response from getBuyerDetails API.
class BuyerDetailsResponse {
  final BuyerProfile buyerProfile;
  final BuyerWorth buyerWorth;
  final List<String> suppliers;
  final List<String> productCategories;
  final List<BuyerTransactionItem> transactions;

  BuyerDetailsResponse({
    required this.buyerProfile,
    required this.buyerWorth,
    required this.suppliers,
    required this.productCategories,
    required this.transactions,
  });

  factory BuyerDetailsResponse.fromJson(Map<String, dynamic> json) {
    final profileMap = json['buyer_profile'];
    final worthMap = json['buyer_worth'];
    final suppliersList = json['suppliers'];
    final pctList = json['product_categories'];
    final txList = json['transactions'];

    return BuyerDetailsResponse(
      buyerProfile: profileMap != null
          ? BuyerProfile.fromJson(Map<String, dynamic>.from(profileMap as Map))
          : BuyerProfile(
              name: '',
              address: '',
              email: '',
              contact: '',
              city: '',
              country: '',
              latlong: '',
            ),
      buyerWorth: worthMap != null
          ? BuyerWorth.fromJson(Map<String, dynamic>.from(worthMap as Map))
          : BuyerWorth(currency: 'USD', totalFc: 0),
      suppliers: suppliersList is List
          ? (suppliersList as List).map((e) => e.toString().trim()).toList()
          : [],
      productCategories: pctList is List
          ? (pctList as List).map((e) => e.toString().trim()).toList()
          : [],
      transactions: txList is List
          ? (txList as List)
              .map((e) => BuyerTransactionItem.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : [],
    );
  }
}
