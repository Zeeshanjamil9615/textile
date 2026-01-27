import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/garment_denim/garment_denim_controller.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GarmentDenimController>();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter by Country', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
              return DropdownMenuItem<String>(value: country, child: Text(country));
            }).toList().cast<DropdownMenuItem<String>>(),
            onChanged: controller.updateCountryFilter,
          )),
          const SizedBox(height: 16),
          const Text('Filter by Importer Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hintText: 'Enter importer name...',
            ),
            onChanged: controller.updateImporterNameFilter,
          ),
          const SizedBox(height: 16),
          const Text('Product Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedProductCategory.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: controller.productCategories.map((category) {
              return DropdownMenuItem<String>(
                value: category, 
                child: Text(category, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
              );
            }).toList().cast<DropdownMenuItem<String>>(),
            onChanged: controller.updateProductCategoryFilter,
          )),
          const SizedBox(height: 24),
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.applyFilterAndFetch(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A9B9B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(() => controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}