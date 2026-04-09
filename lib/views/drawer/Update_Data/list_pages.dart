
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Update_Data/buyer_card.dart';
import 'package:textile/views/drawer/Update_Data/Update_Data_controller.dart';
import 'package:textile/widgets/filter_empty_state.dart';

class updatedataListPage extends StatefulWidget {
  const updatedataListPage({Key? key}) : super(key: key);

  @override
  State<updatedataListPage> createState() => _updatedataListPageState();
}

class _updatedataListPageState extends State<updatedataListPage> {
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
      controller = Get.find<UpdateDataController>();
    } catch (e) {
      try {
        controller = Get.find<UpdateDataController>();
      } catch (e) {
        // If neither exists, create UpdateDataController as default
        controller = Get.put(UpdateDataController());
      }
    }
    
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text('Buyers Country Wise updation', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
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
          )),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.filteredBuyers.isEmpty) {
                return const FilterEmptyState(hasLoadedData: true);
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredBuyers.length,
                itemBuilder: (context, index) {
                  return BuyerCard(
                    key: ValueKey(controller.filteredBuyers[index].serialNumber),
                    buyer: controller.filteredBuyers[index],
                    scrollController: _scrollController,
                    index: index,
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