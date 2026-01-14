
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/Search_Importer_By_Product_Specification_controller.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/buyer_card.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/filter_section.dart';
import 'package:textile/widgets/colors.dart';

class SearchImporterByProductSpecificationListPage extends StatefulWidget {
  const SearchImporterByProductSpecificationListPage({Key? key}) : super(key: key);

  @override
  State<SearchImporterByProductSpecificationListPage> createState() => _SearchImporterByProductSpecificationListPageState();
}

class _SearchImporterByProductSpecificationListPageState extends State<SearchImporterByProductSpecificationListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Try to find either controller - works with both BuyersController and TextileImportersController
    dynamic controller;
    try {
      controller = Get.find<SearchImporterByProductSpecificationController>();
    } catch (e) {
      try {
        controller = Get.find<SearchImporterByProductSpecificationController>();
      } catch (e) {
        // If neither exists, create SearchImporterByProductSpecificationController as default
        controller = Get.put(SearchImporterByProductSpecificationController());
      }
    }
    
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text('Products Database - Filter by Product Specification', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const FilterSection(),
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
        ],
      ),
    );
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