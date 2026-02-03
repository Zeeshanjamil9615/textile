
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/Search_Exporters_by_Cities_controller.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/buyer_card.dart';

class searchExportersByCitiesListPage extends StatefulWidget {
  const searchExportersByCitiesListPage({Key? key}) : super(key: key);

  @override
  State<searchExportersByCitiesListPage> createState() => _searchExportersByCitiesListPageState();
}

class _searchExportersByCitiesListPageState extends State<searchExportersByCitiesListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchExportersByCitiesController>();

    return Stack(
      children: [
        Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                color: Colors.white,
                child: const Text('Sellers Cities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        items: [10, 25, 50, 100]
                            .map((val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(val.toString()),
                                ))
                            .toList(),
                        onChanged: controller.updateEntriesPerPage,
                      ),
                    ),
                    const Text(' entries', style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A9B9B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Showing ${controller.filteredExporters.length} Records',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                  width: 150,
                  child: TextField(
                    onChanged: controller.updateCityFilter,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: Color(0xFF4A9B9B), width: 2),
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
              itemCount: controller.filteredExporters.length,
              itemBuilder: (context, index) {
                return BuyerCard(
                  key: ValueKey(controller.filteredExporters[index].serialNumber),
                  buyer: controller.filteredExporters[index],
                  scrollController: _scrollController,
                  index: index,
                );
              },
            )),
          ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.isLoading.value) return const SizedBox.shrink();
          return Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A9B9B),
                strokeWidth: 3,
              ),
            ),
          );
        }),
      ],
    );
  }
}