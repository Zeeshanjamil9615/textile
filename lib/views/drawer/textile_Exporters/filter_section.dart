import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/textile_Exporters/textile_Exporters_controller.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Try to find either controller - works with both BuyersController and TextileImportersController
    dynamic controller;
    try {
      controller = Get.find<TextileExportersController>();
    } catch (e) {
      try {
        controller = Get.find<TextileExportersController>();
      } catch (e) {
        // If neither exists, create TextileImportersController as default
        controller = Get.put(TextileExportersController());
      }
    }
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Product Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedProductCategory.value,
                      isExpanded: true,
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
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Buyer Ranking', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedBuyerRanking.value,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8F9FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: controller.buyerRankings.map((ranking) {
                        return DropdownMenuItem<String>(
                          value: ranking, 
                          child: Text(ranking, overflow: TextOverflow.ellipsis),
                        );
                      }).toList().cast<DropdownMenuItem<String>>(),
                      onChanged: controller.updateBuyerRankingFilter,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}