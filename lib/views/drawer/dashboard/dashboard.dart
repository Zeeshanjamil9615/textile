import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise.dart';
import 'package:textile/views/drawer/dashboard/dashboard_controller.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background,
      body: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isNarrow = width < 900;
        final isVeryNarrow = width < 650;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: 14),
                  _KpiGrid(
                    crossAxisCount: isVeryNarrow ? 1 : (isNarrow ? 2 : 4),
                    items: const [
                      _KpiData(
                        title: 'Textile Importers',
                        value: '47,117',
                        icon: Icons.check_circle,
                        iconBg: Color(0xFF2D7373),
                        accent: Color(0xFF2D7373),
                      ),
                      _KpiData(
                        title: 'Textile Exporters',
                        value: '1,079',
                        icon: Icons.cancel,
                        iconBg: Color(0xFFE74C3C),
                        accent: Color(0xFFE74C3C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Top Products Section
                  const _TopProducts(),
                  const SizedBox(height: 16),
                  if (isNarrow) ...[
                    const _MapAndCountries(),
                    const SizedBox(height: 16),
                    _Map(),
                    const SizedBox(height: 16),
                    const _TopBrands(),
                  ] else
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _MapAndCountries()),
                        SizedBox(width: 16),
                        Expanded(flex: 4, child: _TopBrands()),
                      ],
                    ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.dashboard_outlined, color: AppColors.primaryDark),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                SizedBox(height: 2),
                Text(
                  'Overview of importers, exporters, countries and brands.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Get.snackbar('Report', 'Dummy report action'),
            icon: const Icon(Icons.description_outlined, size: 18),
            label: const Text('View Report'),
          ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String title;
  final String value;
  final String? subValue;
  final IconData icon;
  final Color iconBg;
  final Color accent;

  const _KpiData({
    required this.title,
    required this.value,
    this.subValue,
    required this.icon,
    required this.iconBg,
    required this.accent,
  });
}

class _KpiGrid extends StatelessWidget {
  final int crossAxisCount;
  final List<_KpiData> items;

  const _KpiGrid({required this.crossAxisCount, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: crossAxisCount == 1 ? 3.2 : 2.5,
      ),
      itemBuilder: (context, index) => _KpiCard(data: items[index]),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: data.iconBg.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.iconBg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: data.accent),
                ),
                if (data.subValue != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    data.subValue!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: data.accent),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.snackbar('Report', 'Dummy report for ${data.title}'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}

// Top Products Section
class _TopProducts extends StatelessWidget {
  const _TopProducts();

  @override
  Widget build(BuildContext context) {
    const products = [
      _ProductData(
        title: 'Bed Linen / Bed...',
        icon: Icons.bed_outlined,
      ),
      _ProductData(
        title: 'Bed Spreads',
        icon: Icons.weekend_outlined,
      ),
      _ProductData(
        title: 'Blankets',
        icon: Icons.bed,
      ),
      _ProductData(
        title: 'Canvas...',
        icon: Icons.brush_outlined,
      ),
      _ProductData(
        title: 'Fabrics',
        icon: Icons.texture_outlined,
      ),
      _ProductData(
        title: 'Grey Fabric',
        icon: Icons.checkroom_outlined,
      ),
      _ProductData(
        title: 'Printed Fabric',
        icon: Icons.print_outlined,
      ),
      _ProductData(
        title: 'Terry Towel',
        icon: Icons.dry_cleaning_outlined,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Products',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width < 600 ? 2 : (width < 900 ? 3 : 4);
              
              return GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, index) => _ProductCard(data: products[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductData {
  final String title;
  final IconData icon;

  const _ProductData({
    required this.title,
    required this.icon,
  });
}

class _ProductCard extends StatelessWidget {
  final _ProductData data;
  const _ProductCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to BuyerProductWise screen
        Get.to(() => BuyerProductWise());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
                padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9EEF2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(data.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),







            
            Flexible(
              child: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapAndCountries extends StatelessWidget {
  const _MapAndCountries();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 6, child: _TopCountries()),
      ],
    );
  }
}

class _Map extends StatelessWidget {
  const _Map();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 5, child: _MapCard()),
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Search Importers on Google Map',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.10),
                  AppColors.primaryDark.withOpacity(0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFFE9EEF2)),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Center(
                    child: Icon(Icons.map_outlined, size: 56, color: AppColors.primaryDark),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, size: 18, color: AppColors.primaryDark),
                        SizedBox(width: 6),
                        Text('Map preview', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => Get.snackbar('Map', 'Dummy open map'),
            child: const Text('Open Map Search'),
          ),
        ],
      ),
    );
  }
}

class _TopCountries extends StatelessWidget {
  const _TopCountries();

  @override
  Widget build(BuildContext context) {
    const countries = [
      ('🇺🇸', 'United States'),
      ('🇨🇳', 'China'),
      ('🇬🇧', 'United Kingdom'),
      ('🇩🇪', 'Germany'),
      ('🇫🇷', 'France'),
      ('🇮🇹', 'Italy'),
      ('🇪🇸', 'Spain'),
      ('🇳🇱', 'Netherlands'),
      ('🇧🇪', 'Belgium'),
      ('🇹🇷', 'Turkey'),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top 10 Textile Importing Countries',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: countries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = countries[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9EEF2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 34,
                        width: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE9EEF2)),
                        ),
                        child: Text(item.$1, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.$2,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBrands extends StatelessWidget {
  const _TopBrands();

  @override
  Widget build(BuildContext context) {
    const brands = [
      ('Ikea', Icons.chair_alt_outlined, Color(0xFFF1C40F)),
      ('Adidas', Icons.sports_soccer, Color(0xFF111111)),
      ('ZARA', Icons.storefront_outlined, Color(0xFF95A5A6)),
      ('H&M', Icons.local_mall_outlined, Color(0xFFE74C3C)),
      ('Nike', Icons.directions_run, Color(0xFF2D7373)),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Brands',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          ...brands.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE9EEF2)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: b.$3.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(b.$2, color: b.$3),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        b.$1,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.snackbar('Brand', 'Dummy open ${b.$1}'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('View'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


