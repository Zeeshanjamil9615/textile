import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/models/country_model.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers_controller.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers_hub_controller.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/custom_app_bar.dart';

/// Web-style country grid (mobile layout). Drawer opens this first; tap country → importer list + API.
class TextileImportersHub extends StatelessWidget {
  const TextileImportersHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextileImportersHubController());

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFF4F6F9),
      body: Obx(() {
        if (controller.isLoading.value && controller.countries.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (controller.errorMessage.value.isNotEmpty && controller.countries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => controller.loadCountries(),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primaryDark),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final list = controller.filteredCountries;
        final total = controller.countries.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: controller.setSearch,
                decoration: InputDecoration(
                  hintText: 'Search country...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryDark),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE9EEF2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: TextileImportersHubController.regionTabs.map((r) {
                  return Obx(() {
                    final sel = controller.selectedRegion.value == r;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          r == 'All' ? 'All Countries' : r,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: sel ? Colors.white : AppColors.primaryDark,
                          ),
                        ),
                        selected: sel,
                        onSelected: (_) => controller.setRegion(r),
                        selectedColor:  AppColors.primary ,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: sel ? const Color(0xFFE67E22) : const Color(0xFFE9EEF2)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Text(
                '$total countries available',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE67E22),
                ),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('No countries match your filters.'))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _CountryCard(
                          country: list[index],
                          onTap: () => _openImportersForCountry(list[index]),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  void _openImportersForCountry(CountryModel country) {
    final ctrl = Get.isRegistered<TextileImportersController>()
        ? Get.find<TextileImportersController>()
        : Get.put(TextileImportersController());
    ctrl.selectedCountry.value = country.country;
    ctrl.hasShownInitialFilterSheet.value = true;
    ctrl.isLoadingBuyers.value = true;
    Get.to(() => const TextileImporters());
    Future.microtask(() => ctrl.applyCountryAndFetch(country: country.country));
  }
}

class _CountryCard extends StatelessWidget {
  final CountryModel country;
  final VoidCallback onTap;

  const _CountryCard({required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final flagUrl = country.flagUrl.trim();

    return Material(
      color: AppColors.primaryDark,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: flagUrl.isEmpty
                    ? Text(
                        country.country.isNotEmpty ? country.country[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    : ClipOval(
                        child: Image.network(
                          flagUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.flag, color: Colors.white70, size: 28),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                country.country,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined, size: 14, color: Color(0xFFFFD54F)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Total: ${country.totalRecords}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFD54F),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
