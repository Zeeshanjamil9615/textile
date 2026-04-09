
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/garment_socks_knitted/buyer_card.dart';
import 'package:textile/views/drawer/garment_socks_knitted/garment_socks_knitted_controller.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/filter_empty_state.dart';

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
    final controller = Get.put(GarmentSocksKnittedController());
    
    // Automatically open filter sheet when screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.openFilterSheetIfNeeded(context);
    });
    
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
         
          Expanded(
            child: Obx(
              () {
                if (controller.filteredBuyers.isEmpty && !controller.isLoading.value) {
                  return FilterEmptyState(
                    hasLoadedData: controller.hasLoadedData.value,
                  );
                }
                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      )),
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