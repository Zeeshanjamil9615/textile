
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Email_Importers_City_Wise/Email_Importers_City_Wise_controller.dart';
import 'package:textile/views/drawer/Email_Importers_City_Wise/buyer_card.dart';
import 'package:textile/views/drawer/textile_importers/filter_section.dart';

class CitywiseListPage extends StatefulWidget {
  const CitywiseListPage({Key? key}) : super(key: key);

  @override
  State<CitywiseListPage> createState() => _CitywiseListPageState();
}

class _CitywiseListPageState extends State<CitywiseListPage> {
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
      controller = Get.find<EmailImportersCityWiseController>();
    } catch (e) {
      try {
        controller = Get.find<EmailImportersCityWiseController>();
      } catch (e) {
        // If neither exists, create EmailImportersCityWiseController as default
        controller = Get.put(EmailImportersCityWiseController());
      }
    }
    
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text('Buyers Cities', 
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
                    items: [10, 25, 50, 100].map((val) {
                      return DropdownMenuItem(value: val, child: Text(val.toString()));
                    }).toList(),
                    onChanged: controller.updateEntriesPerPage,
                  ),
                ),
                const Text(' entries', style: TextStyle(fontSize: 14)),
                const Spacer(),
                // Search field
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
              itemCount: controller.filteredBuyers.length,
              itemBuilder: (context, index) {
                return BuyerCard(
                  key: ValueKey(controller.filteredBuyers[index].serialNumber),
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