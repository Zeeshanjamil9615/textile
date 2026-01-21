
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/Search_Exporter_By_Product_Specification_controller.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/buyer_card.dart';
import 'package:textile/widgets/colors.dart';

class SearchExporterByProductSpecificationListPage extends StatefulWidget {
  const SearchExporterByProductSpecificationListPage({Key? key}) : super(key: key);

  @override
  State<SearchExporterByProductSpecificationListPage> createState() => _SearchExporterByProductSpecificationListPageState();
}

class _SearchExporterByProductSpecificationListPageState extends State<SearchExporterByProductSpecificationListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Try to find either controller - works with both BuyersController and TextileExportersController
    dynamic controller;
    try {
       controller = Get.put(SearchExporterByProductSpecificationController());
    } catch (e) {
      try {
        controller = Get.put(SearchExporterByProductSpecificationController());
      } catch (e) {
        // If neither exists, create SearchExporterByProductSpecificationController as default
        controller = Get.put(SearchExporterByProductSpecificationController());
      }
    }
    
    return Obx(() {
      final bool loading = controller.isLoading.value;
      return Stack(
        children: [
          Container(
            color: const Color(0xFFF5F5F5),
            child: Column(
              children: [
          // Search bar at top with filter icon
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      hintText: 'Enter product name...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    ),
                    onChanged: controller.updateProductNameFilter,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: AppColors.primaryDark),
                  onPressed: () => controller.showFilterBottomSheet(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryDark.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ChipPill(
                        text: 'Showing ${controller.filteredBuyers.length} Records',
                        onClose: null,
                      ),
                      _ChipPill(
                        text: controller.selectedProductCategory.value,
                        onClose: () => controller.updateProductCategoryFilter(
                          controller.productCategories.isNotEmpty
                              ? controller.productCategories.first
                              : controller.selectedProductCategory.value,
                        ),
                      ),
                      _ChipPill(
                        text: 'From ${controller.selectedCountry.value}',
                        onClose: controller.clearCountryFilter,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          Expanded(
            child: Obx(() => ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredBuyers.length,
              itemBuilder: (context, index) {
                return BuyerCard(
                  key: ValueKey(controller.filteredBuyers[index].sr),
                  buyer: controller.filteredBuyers[index],
                  scrollController: _scrollController,
                  index: index,
                );
              },
            )),
          ),
          if (loading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    });
  }
}

class _ChipPill extends StatelessWidget {
  final String text;
  final VoidCallback? onClose;

  const _ChipPill({required this.text, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onClose != null) ...[
            GestureDetector(
              onTap: onClose,
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 6),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}