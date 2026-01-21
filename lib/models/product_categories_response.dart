import 'package:textile/models/product_category_model.dart';

class ProductCategoriesResponse {
  final bool status;
  final int count;
  final List<ProductCategoryModel> data;

  ProductCategoriesResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory ProductCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return ProductCategoriesResponse(
      status: json['status'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    ProductCategoryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'count': count,
      'data': data.map((category) => category.toJson()).toList(),
    };
  }
}
