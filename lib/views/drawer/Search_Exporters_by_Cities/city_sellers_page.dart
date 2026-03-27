import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/exporter_city_seller_item.dart';
import 'package:textile/views/drawer/buyer_profile/buyer_profile.dart';
import 'package:textile/widgets/colors.dart';

class CitySellersController extends GetxController {
  final String city;
  CitySellersController({required this.city});

  final sellers = <ExporterCitySellerItem>[].obs;
  final filteredSellers = <ExporterCitySellerItem>[].obs;
  final isLoading = false.obs;
  final search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCitySellers();
  }

  Future<void> fetchCitySellers() async {
    try {
      isLoading.value = true;
      final api = ApiService();
      final response = await api.exporterCityWiseS(city: city);
      if (response.status == 200 && response.data != null) {
        sellers.assignAll(response.data!);
        applySearch('');
      } else {
        sellers.clear();
        filteredSellers.clear();
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      sellers.clear();
      filteredSellers.clear();
      Get.snackbar(
        'Error',
        'Failed to load sellers.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applySearch(String value) {
    search.value = value;
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredSellers.assignAll(sellers);
      return;
    }
    filteredSellers.assignAll(
      sellers.where((s) {
        return s.importer.toLowerCase().contains(query) ||
            s.address.toLowerCase().contains(query) ||
            s.contactNumber.toLowerCase().contains(query);
      }),
    );
  }
}

class CitySellersPage extends StatelessWidget {
  final String city;
  const CitySellersPage({Key? key, required this.city}) : super(key: key);

  void _showListDialog(
    BuildContext context, {
    required String title,
    required List<String> items,
  }) {
    final list = items.where((e) => e.trim().isNotEmpty).toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: list.isEmpty
              ? const Text('No data available')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('\u2022 ${list[index]}'),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CitySellersController>(
      init: CitySellersController(city: city),
      builder: (_) {
        final controller = Get.find<CitySellersController>();
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F9),
          appBar: AppBar(
            title: Text('Sellers from $city'),
            backgroundColor: const Color(0xFF2D7373),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    onChanged: controller.applySearch,
                    decoration: InputDecoration(
                      hintText: 'Search sellers...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.filteredSellers.isEmpty) {
                    return const Center(child: Text('No sellers found'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: controller.filteredSellers.length,
                    itemBuilder: (context, index) {
                      final s = controller.filteredSellers[index];
                      final displayName = s.importer.isEmpty ? '—' : s.importer;
                      final displayAddress = s.address.isEmpty ? '—' : s.address;
                      final displayCity = s.city.isEmpty ? city : s.city;
                      final displayPhone =
                          s.contactNumber.isEmpty ? '—' : s.contactNumber;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F6B73)
                                          .withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.storefront_outlined,
                                      size: 18,
                                      color: Color(0xFF0F6B73),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => const BuyerProfilePage(),
                                          arguments: s.importer,
                                        );
                                      },
                                      child: Text(
                                        displayName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: Color(0xFF2D7373),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D7373)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '#${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2D7373),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Divider(height: 12),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      displayAddress,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'City: $displayCity',
                                        style: const TextStyle(fontSize: 12.5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Phone: $displayPhone',
                                        style: const TextStyle(fontSize: 12.5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0F6B73),
                                        foregroundColor: AppColors.textWhite,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        _showListDialog(
                                          context,
                                          title: 'Category Details',
                                          items: s.categories,
                                        );
                                      },
                                      child: const Text('Show Categories'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD9902B),
                                        foregroundColor: AppColors.textWhite,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        final countries = s.exporterCountries.isEmpty
                                            ? (s.country.trim().isEmpty
                                                ? <String>[]
                                                : <String>[s.country.trim()])
                                            : s.exporterCountries;
                                        _showListDialog(
                                          context,
                                          title: 'Exporter Countries',
                                          items: countries,
                                        );
                                      },
                                      child: const Text('Show Countries'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      },
    );
  }
}
