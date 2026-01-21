
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/garment_socks_knitted/buyer_card.dart';
import 'package:textile/views/drawer/garment_socks_knitted/filter_section.dart';
import 'package:textile/views/drawer/garment_socks_knitted/garment_socks_knitted_controller.dart';
import 'package:textile/widgets/colors.dart';

class GarmentSocksKnittedListPage extends StatefulWidget {
  const GarmentSocksKnittedListPage({Key? key}) : super(key: key);

  @override
  State<GarmentSocksKnittedListPage> createState() => _GarmentSocksKnittedListPageState();
}

class _GarmentSocksKnittedListPageState extends State<GarmentSocksKnittedListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Try to find either controller - works with both impotersController and TextileImportersController
    dynamic controller;
    try {
      controller = Get.find<GarmentSocksKnittedController>();
    } catch (e) {
      try {
        controller = Get.find<GarmentSocksKnittedController>();
      } catch (e) {
        // If neither exists, create GarmentSocksKnittedController as default
        controller = Get.put(GarmentSocksKnittedController());
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
                      hintText: 'Enter importer name...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    ),
                    onChanged: controller.updateImporterNameFilter,
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
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Text('Show ', style: TextStyle(fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButton<int>(
                    value: controller.entriesPerPage.value,
                    underline: const SizedBox(),
                    items: [10, 25, 50, 100].map((val) {
                      return DropdownMenuItem(value: val, child: Text(val.toString()));
                    }).toList(),
                    onChanged: controller.updateEntriesPerPage,
                  ),
                ),
                const Text(' entries', style: TextStyle(fontSize: 14)),
                const Spacer(),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A9B9B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Showing ' + controller.filteredBuyers.length.toString() + ' Records',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: GestureDetector(
                    onTap: controller.clearCountryFilter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A9B9B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.close, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text('FROM ' + controller.selectedCountry.value,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          Expanded(
            child: Obx(() => ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredBuyers.length,
              itemBuilder: (context, index) {
                return BuyerCard(
                  key: ValueKey(controller.filteredBuyers[index].id),
                  buyer: controller.filteredBuyers[index],
                  scrollController: _scrollController,
                  index: index,
                );
              },
            )),
          ),
        ],
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