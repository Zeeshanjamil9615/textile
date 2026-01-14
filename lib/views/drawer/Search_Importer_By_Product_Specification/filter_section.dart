import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/Search_Importer_By_Product_Specification_controller.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchImporterByProductSpecificationController>();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter by Country',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCountry.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: controller.countries.map((country) {
              return DropdownMenuItem(value: country, child: Text(country));
            }).toList(),
            onChanged: controller.updateCountryFilter,
          )),
          const SizedBox(height: 16),
          const Text('Filter by Product Name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Enter product name...',
            ),
            onChanged: controller.updateProductNameFilter,
          ),
          const SizedBox(height: 16),
          const Text('Filter by Product Specification',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedProductCategory.value,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: controller.productCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: controller.updateProductCategoryFilter,
            ),
          ),
        ],
      ),
    );
  }
}