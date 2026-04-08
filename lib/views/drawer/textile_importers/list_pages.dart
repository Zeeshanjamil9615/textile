
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/textile_importers/buyer_card.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers_controller.dart';
import 'package:textile/widgets/colors.dart';

class impotersListPage extends StatefulWidget {
  const impotersListPage({Key? key}) : super(key: key);

  @override
  State<impotersListPage> createState() => _impotersListPageState();
}

class _impotersListPageState extends State<impotersListPage> {
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
      controller = Get.find<TextileImportersController>();
    } catch (e) {
      // If it doesn't exist yet, create TextileImportersController as default
      controller = Get.put(TextileImportersController());
    }

    // Automatically open filter sheet when screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.openFilterSheetIfNeeded(context);
    });
    
    return Obx(() {
      final bool loading = controller.isLoadingBuyers.value;
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
                    onChanged: controller.updateExporterNameFilter,
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
         
                const SizedBox(width: 8),
                
          Expanded(
            child: Obx(() => ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.filteredExporters.length,
              itemBuilder: (context, index) {
                return BuyerCard(
                  key: ValueKey(controller.filteredExporters[index].id),
                  buyer: controller.filteredExporters[index],
                  scrollController: _scrollController,
                  index: index,
                );
              },
            )),
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