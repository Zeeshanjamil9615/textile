/// Single item from getTextileExporters API.
class TextileExporterItem {
  final int sr;
  final String id;
  final String exporter;
  final String country;
  final String pct;

  TextileExporterItem({
    required this.sr,
    required this.id,
    required this.exporter,
    required this.country,
    required this.pct,
  });

  factory TextileExporterItem.fromJson(Map<String, dynamic> json) {
    return TextileExporterItem(
      sr: (json['sr'] is num)
          ? (json['sr'] as num).toInt()
          : int.tryParse(json['sr']?.toString() ?? '0') ?? 0,
      id: json['id']?.toString() ?? '',
      exporter: json['exporter']?.toString() ?? '',
      country: (json['country']?.toString() ?? '').trim(),
      pct: json['pct']?.toString() ?? '',
    );
  }
}
