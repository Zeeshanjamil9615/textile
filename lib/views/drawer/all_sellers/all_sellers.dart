import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/add_folder/add_folder_controller.dart';
import 'package:textile/views/drawer/all_sellers/all_sellers_controller.dart';
import 'package:textile/views/drawer/buyer_profile/buyer_profile.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers_controller.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/custom_app_bar.dart';
import 'package:textile/widgets/folder_selection_bottom_sheet.dart';

class TextileImporters extends StatefulWidget {
  const TextileImporters({Key? key}) : super(key: key);

  @override
  State<TextileImporters> createState() => _TextileImportersState();
}

class _TextileImportersState extends State<TextileImporters> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllSellersController());

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const impotersListPage(),
    );
  }
}

class BuyerCard extends StatelessWidget {
  final BuyerModel buyer;
  final ScrollController? scrollController;
  final int? index;
  
  const BuyerCard({
    Key? key, 
    required this.buyer,
    this.scrollController,
    this.index,
  }) : super(key: key);

  void _scrollToCard(BuildContext context) {
    if (scrollController != null && index != null) {
      // Use Scrollable.ensureVisible to scroll the card into view
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.1, // Position card near top (10% from top)
        );
      }
    }         
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _scrollToCard(context),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A9B9B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(buyer.id, 
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4A9B9B))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const BuyerProfilePage(), arguments: buyer.importerName);
                      },
                      child: Text(
                        buyer.importerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D7373),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DetailRow(icon: Icons.flag, label: 'Country', value: buyer.country),
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.category, label: 'Product Category', value: buyer.productCategory),
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.star, label: 'Ranking', value: buyer.ranking, 
                valueColor: _getRankingColor(buyer.ranking)),
              const SizedBox(height: 8),
              _DetailRow(icon: Icons.attach_money, label: 'Buyers Worth', 
                value: '\$' + buyer.buyersWorth.toStringAsFixed(2), valueColor: Colors.green),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ensure AddFolderController is initialized
                    if (!Get.isRegistered<AddFolderController>()) {
                      Get.put(AddFolderController());
                    }
                    showFolderSelectionBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7373),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Edit', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getRankingColor(String ranking) {
    switch (ranking.toLowerCase()) {
      case 'high': return Colors.green;
      case 'medium': return Colors.orange;
      case 'low': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  
  const _DetailRow({required this.icon, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label + ': ', style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 13, color: valueColor ?? Colors.black87, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Try to find either controller - works with both BuyersController and TextileImportersController
    dynamic controller;
    try {
      controller = Get.find<AllSellersController>();
    } catch (e) {
      try {
        controller = Get.find<AllSellersController>();
      } catch (e) {
        // If neither exists, create AllSellersController as default
        controller = Get.put(AllSellersController());
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
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.applyFilterAndFetch(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
            ),
          ),
        ],
      ),
    );
  }
}

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
                    child: Obx(() => Text('Showing ' + controller.filteredExporters.length.toString() + ' Records',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => controller.selectedCountry.value != 'All'
                    ? Flexible(
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
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          )),
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