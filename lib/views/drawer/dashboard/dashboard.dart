import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/Search_Exporters_by_Cities.dart';
import 'package:textile/views/drawer/add_folder/add_folder.dart';
import 'package:textile/views/drawer/dashboard/dashboard_controller.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/all_sellers/all_sellers.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshDashboardData();
    });
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _DashboardBody(),
          Obx(() {
            if (!controller.isLoadingProductWise.value) return const SizedBox.shrink();
            return Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
class _DashboardBody extends StatelessWidget {
  const _DashboardBody();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
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
                  Obx(() {
                    final items = [
                      _KpiData(
                        title: 'Textile Importers',
                        value: controller.importerCount.value.toString(),
                        icon: Icons.check_circle,
                        iconBg: const Color(0xFF2D7373),
                        accent: const Color(0xFF2D7373),
                        loading: controller.isLoadingCounts.value,
                        onView: () => Get.to(() => const TextileImporters()),
                      ),
                      _KpiData(
                        title: 'Textile Exporters',
                        value: controller.exporterCount.value.toString(),
                        icon: Icons.local_shipping_outlined,
                        iconBg: const Color(0xFFE67E22),
                        accent: const Color(0xFFE67E22),
                        loading: controller.isLoadingCounts.value,
                        onView: () => Get.to(() => const SearchExportersByCities()),
                      ),
                        _KpiData(
                        title: 'My Folder',
                        value: '6',
                        icon: Icons.folder_open,
                        iconBg: const Color(0xFFE67E22),
                        accent: const Color(0xFFE67E22),
                        loading: controller.isLoadingCounts.value,
                        onView: () => Get.to(() => const AddFolderScreen()),
                      ),
                    
                    ];
                    return _KpiGrid(
                      crossAxisCount: isVeryNarrow ? 1 : (isNarrow ? 2 : 4),
                      items: items,
                    );
                  }),
                  const SizedBox(height: 16),
                  // Top Products Section
                  _TopProducts(controller: controller),
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
    
class _KpiData {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color accent;
  final bool loading;
  final VoidCallback? onView;

  const _KpiData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.accent,
    this.loading = false,
    this.onView,
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
                data.loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        data.value,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: data.accent),
                      ),
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
            onPressed: data.onView,
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

// Helper function to get icon for product
IconData _getProductIcon(String productName) {
  final name = productName.toLowerCase();
  if (name.contains('bed linen') || name.contains('bed sheet') || name.contains('blanket')) {
    return Icons.hotel_rounded;
  } else if (name.contains('bed spread')) {
    return Icons.layers;
  } else if (name.contains('canvas')) {
    return Icons.layers;
  } else if (name.contains('fabric') && !name.contains('print')) {
    return FontAwesomeIcons.tshirt;
  } else if (name.contains('print')) {
    return Icons.print;
  } else if (name.contains('towel')) {
    return FontAwesomeIcons.bath;
  }
  return Icons.category; // Default icon           
}

// Top Products Section
class _TopProducts extends StatelessWidget {
  final DashboardController controller;
  const _TopProducts({required this.controller});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Products',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 14),
          Obx(() {
            if (controller.isLoadingTopProducts.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (controller.topProducts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No top products found'),
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width < 600 ? 2 : (width < 900 ? 3 : 4);
                return GridView.builder(
                  itemCount: controller.topProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.topProducts[index];
                    return _ProductCard(
                      title: item.name,
                      icon: _getProductIcon(item.name),
                      onTap: () => controller.goToProductWise(item),
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _ProductCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
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

class _MapCard extends StatefulWidget {
  const _MapCard();

  @override
  State<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<_MapCard> {
  GoogleMapController? _mapController;
  static final CameraPosition _initialPosition = CameraPosition(
    target: const LatLng(37.7749, -122.4194), // Default to San Francisco
    zoom: 10,
  );

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

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
              border: Border.all(color: const Color(0xFFE9EEF2)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
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
      ('🇯🇵', 'Japan'),
      ('🇦🇺', 'Australia'),
      ('🇦🇪', 'United Arab Emirates'),
      ('🇧🇩', 'Bangladesh'),
      ('🇧🇷', 'Brazil'),
      ('🇨🇦', 'Canada'),
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
      ('Ikea', 'assets/image/image1.png'),
      ('Adidas', 'assets/image/image2.png'),
      ('ZARA', 'assets/image/image3.png'),
      ('Marks & Spencer', 'assets/image/image4.png'),
      ('JCPenney', 'assets/image/image5.png'),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        b.$2,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        b.$1,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
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



