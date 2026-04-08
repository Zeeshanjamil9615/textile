import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/Search_Importer_By_Product_Specification_controller.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/buyer_card.dart';
import 'package:textile/widgets/colors.dart';

class SearchImporterByProductSpecificationListPage extends StatefulWidget {
  const SearchImporterByProductSpecificationListPage({Key? key})
      : super(key: key);

  @override
  State<SearchImporterByProductSpecificationListPage> createState() =>
      _SearchImporterByProductSpecificationListPageState();
}

class _SearchImporterByProductSpecificationListPageState
    extends State<SearchImporterByProductSpecificationListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(SearchImporterByProductSpecificationController());

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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            hintText: 'Enter product name...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          onChanged: controller.updateProductNameFilter,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: AppColors.primaryDark,
                        ),
                        onPressed: () =>
                            controller.showFilterBottomSheet(context),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColors.primaryDark.withOpacity(0.1),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.filteredRecordList.length,
                      itemBuilder: (context, index) {
                        final item =
                            controller.filteredRecordList[index];
                        return MadeupRecordCard(
                          key: ValueKey('${item.importer}_$index'),
                          item: item,
                          index: index,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
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
