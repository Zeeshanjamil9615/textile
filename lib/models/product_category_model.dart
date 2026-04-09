class ProductCategoryModel {
  final String id;
  final String name;
  final String icon;
  final String condition;

  ProductCategoryModel({
    required this.id,
    required this.name,
    this.icon = '',
    required this.condition,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      condition: json['condition']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'condition': condition};
  }
}
