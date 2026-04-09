import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise_controller.dart';
import 'package:textile/widgets/filter_empty_state.dart';

class BuyerProductWiseCategoryGridPage extends StatelessWidget {
  const BuyerProductWiseCategoryGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerProductWiseController>();

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      onChanged: (v) => controller.categorySearch.value = v,
                      decoration: InputDecoration(
                        hintText: 'Search category...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Obx(
                  () => Text(
                    '${controller.filteredCategories.length} categories',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.productCategoriesWithIds.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = controller.filteredCategories;
              if (list.isEmpty) {
                return const FilterEmptyState(
                  hasLoadedData: true,
                  messageNoResults: 'No categories found.',
                  icon: Icons.category_outlined,
                );
              }

              final width = MediaQuery.of(context).size.width;
              final crossAxisCount = width >= 900
                  ? 4
                  : width >= 600
                      ? 3
                      : 2;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.9,
                ),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final c = list[i];
                  final icon = c.icon.trim().isEmpty ? '🧵' : c.icon.trim();
                  return Material(
                    color: const Color(0xFF0F6B73),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => controller.openCategory(c),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                icon,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                c.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

