import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/models/brand_buyer_item.dart';
import 'package:textile/views/drawer/buyer_profile/buyer_profile.dart';
import 'package:textile/views/drawer/dashboard/top_brand_buyers/top_brand_buyers_controller.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class TopBrandBuyersPage extends StatelessWidget {
  final String brandName;
  final String apiBrandValue;

  const TopBrandBuyersPage({
    Key? key,
    required this.brandName,
    required this.apiBrandValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tag = 'topBrandBuyers:$apiBrandValue';
    if (!Get.isRegistered<TopBrandBuyersController>(tag: tag)) {
      Get.put(TopBrandBuyersController(apiBrandValue: apiBrandValue), tag: tag);
    }
    final controller = Get.find<TopBrandBuyersController>(tag: tag);

    return Scaffold(
      appBar: CustomAppBar(
        title: brandName.toUpperCase(),
        showBack: true,
      ), 
      backgroundColor: const Color(0xFFF4F6F9),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4A9B9B)),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => controller.fetchResults(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A9B9B),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final items = controller.results;
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No buyers found for this brand.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchResults(),
          color: const Color(0xFF4A9B9B),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            children: [
              _TableHeader(brandName: brandName),
              const SizedBox(height: 10),
              ...items.map(
                (e) => _BuyerRow(
                  item: e,
                  onTap: () => Get.to(
                    () => const BuyerProfilePage(),
                    arguments: e.importer,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String brandName;

  const _TableHeader({required this.brandName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'Top Brand Name',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Country',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2C3E50)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerRow extends StatelessWidget {
  final BrandBuyerItem item;
  final VoidCallback onTap;

  const _BuyerRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9EEF2)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  item.importer.isEmpty ? '—' : item.importer,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF2C3E50)),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  item.country.isEmpty ? '—' : item.country,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

