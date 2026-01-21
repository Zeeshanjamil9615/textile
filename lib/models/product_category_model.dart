class ProductCategoryModel {
  final String id;
  final String name;
  final String condition;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.condition,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      condition: json['condition']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'condition': condition};
  }
}
