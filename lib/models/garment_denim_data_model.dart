class GarmentDenimDataModel {
  final String id;
  final String importer;
  final String country;
  final String pctCode;
  final String pctName;
  final double scoreSum;
  final String scoreSumFormatted;
  final int ranking;
  final String detailsUrl;

  GarmentDenimDataModel({
    required this.id,
    required this.importer,
    required this.country,
    required this.pctCode,
    required this.pctName,
    required this.scoreSum,
    required this.scoreSumFormatted,
    required this.ranking,
    required this.detailsUrl,
  });

  factory GarmentDenimDataModel.fromJson(Map<String, dynamic> json) {
    return GarmentDenimDataModel(
      id: json['id']?.toString() ?? '',
      importer: json['importer']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pctCode: json['pct_code']?.toString() ?? '',
      pctName: json['pct_name']?.toString() ?? '',
      scoreSum: (json['score_sum'] is num)
          ? (json['score_sum'] as num).toDouble()
          : double.tryParse(json['score_sum']?.toString() ?? '0') ?? 0.0,
      scoreSumFormatted: json['score_sum_formatted']?.toString() ?? '',
      ranking: json['ranking'] is int
          ? json['ranking'] as int
          : int.tryParse(json['ranking']?.toString() ?? '0') ?? 0,
      detailsUrl: json['details_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'importer': importer,
      'country': country,
      'pct_code': pctCode,
      'pct_name': pctName,
      'score_sum': scoreSum,
      'score_sum_formatted': scoreSumFormatted,
      'ranking': ranking,
      'details_url': detailsUrl,
    };
  }
}
