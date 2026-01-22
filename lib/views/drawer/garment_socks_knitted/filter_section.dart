import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/garment_socks_knitted/garment_socks_knitted_controller.dart';
import 'package:textile/widgets/colors.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GarmentSocksKnittedController());
    
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
          const SizedBox(height: 16),
          const Text('Filter by Buyer Ranking',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedBuyerRanking.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: controller.buyerRankings.map((ranking) {
              return DropdownMenuItem(value: ranking, child: Text(ranking));
            }).toList(),
            onChanged: controller.updateBuyerRankingFilter,
          )),
          const SizedBox(height: 24),
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      await controller.fetchGarmentSocksKnittedData();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              child: controller.isLoading.value
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          )),
        ],
      ),
    );
  }
}