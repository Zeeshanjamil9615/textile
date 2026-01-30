/// Single item from getFilteredDenimList API.
class FilteredDenimListItem {
  final String description;
  final String country;
  final String importer;

  FilteredDenimListItem({
    required this.description,
    required this.country,
    required this.importer,
  });

  factory FilteredDenimListItem.fromJson(Map<String, dynamic> json) {
    return FilteredDenimListItem(
      description: json['description']?.toString() ?? '',
      country: (json['country']?.toString() ?? '').trim(),
      importer: json['importer']?.toString() ?? '',
    );
  }
}
