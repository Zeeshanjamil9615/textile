class GarmentSocksKnittedDataModel {
  final String id;
  final String importerName;
  final String country;
  final String pctCode;
  final double totalValue;
  final String totalValueFormatted;

  GarmentSocksKnittedDataModel({
    required this.id,
    required this.importerName,
    required this.country,
    required this.pctCode,
    required this.totalValue,
    required this.totalValueFormatted,
  });

  factory GarmentSocksKnittedDataModel.fromJson(Map<String, dynamic> json) {
    return GarmentSocksKnittedDataModel(
      id: json['id']?.toString() ?? '',
      importerName: json['importer_name']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pctCode: json['pct_code']?.toString() ?? '',
      totalValue: (json['total_value'] is num)
          ? (json['total_value'] as num).toDouble()
          : double.tryParse(json['total_value']?.toString() ?? '0') ?? 0.0,
      totalValueFormatted: json['total_value_formatted']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'importer_name': importerName,
      'country': country,
      'pct_code': pctCode,
      'total_value': totalValue,
      'total_value_formatted': totalValueFormatted,
    };
  }
}




