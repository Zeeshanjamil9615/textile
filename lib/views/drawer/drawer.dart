import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/models/user_model.dart';
import 'package:textile/views/auth/login_page.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise_controller.dart';
import 'package:textile/views/drawer/Email_Importers_City_Wise/Email_Importers_City_Wise.dart';
import 'package:textile/views/drawer/Email_Importers_City_Wise/Email_Importers_City_Wise_controller.dart';
import 'package:textile/views/drawer/Email_Importers_Country_Wise/Email_Importers_Country_Wise.dart';
import 'package:textile/views/drawer/Email_Importers_Country_Wise/Email_Importers_Country_Wise_controller.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/Search_Exporter_By_Product_Specification.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/Search_Exporter_By_Product_Specification_controller.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/Search_Exporters_by_Cities.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/Search_Exporters_by_Cities_controller.dart';
import 'package:textile/views/drawer/Search_Garment_Importer_By_Product_Specification/search_garment.dart';
import 'package:textile/views/drawer/Search_Garment_Importer_By_Product_Specification/search_garment_controller.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/Search_Importer_By_Product_Specification.dart';
import 'package:textile/views/drawer/Search_Importer_By_Product_Specification/Search_Importer_By_Product_Specification_controller.dart';
import 'package:textile/views/drawer/Update_Data/Update_Data.dart';
import 'package:textile/views/drawer/Update_Data/Update_Data_controller.dart';
import 'package:textile/views/drawer/add_folder/add_folder.dart';
import 'package:textile/views/drawer/add_folder/add_folder_controller.dart';
import 'package:textile/views/drawer/buyers/buyer_controller.dart';
import 'package:textile/views/drawer/buyers/buyers.dart';
import 'package:textile/views/drawer/dashboard/dashboard.dart';    
import 'package:textile/views/drawer/dashboard/dashboard_controller.dart';
import 'package:textile/views/drawer/garment_denim/garment_denim.dart';
import 'package:textile/views/drawer/garment_denim/garment_denim_controller.dart';
import 'package:textile/views/drawer/garment_socks_knitted/garment_socks_knitted.dart';
import 'package:textile/views/drawer/garment_socks_knitted/garment_socks_knitted_controller.dart';
import 'package:textile/views/drawer/search_danim/search_danim.dart';
import 'package:textile/views/drawer/search_danim/search_danim_controller.dart';
import 'package:textile/views/drawer/textile_Exporters/textile_Exporters.dart';
import 'package:textile/views/drawer/textile_Exporters/textile_Exporters_controller.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check current route to determine selected item
    final currentRoute = Get.currentRoute;

    final isDashboard =
        currentRoute.contains('Dashboard') ||
        Get.isRegistered<DashboardController>();
    final isTextileImporters =
        currentRoute.contains('TextileImporters') ||
        (Get.isRegistered<TextileImportersController>());
    final isBuyers =
        currentRoute.contains('Buyers') || Get.isRegistered<BuyersController>();
         final isBuyerProductWise =
        currentRoute.contains('BuyerProductWise') || Get.isRegistered<BuyerProductWiseController>();
    final isGarmentSocksKnitted =
        currentRoute.contains('GarmentSocksKnitted') ||
        Get.isRegistered<GarmentSocksKnittedController>();
        
    final isSearchGarmentImporter =
        currentRoute.contains('SearchGarmentImporter') ||
        Get.isRegistered<
          SearchGarmentImporterByProductSpecificationController
        >();
    final isGarmentDanim =
        currentRoute.contains('GarmentDanim') ||
        Get.isRegistered<GarmentDenimController>();
    final isSearchDanim =
        currentRoute.contains('SearchDanim') ||
        Get.isRegistered<SearchDanimController>();
    final isEmailImportersCityWise =
        currentRoute.contains('EmailImportersCityWise') ||
        Get.isRegistered<EmailImportersCityWiseController>();
    final isEmailImportersCountryWise =
        currentRoute.contains('EmailImportersCountryWise') ||
        Get.isRegistered<EmailImportersCountryWiseController>();

    final isSearchImporterByProductSpecification =
        currentRoute.contains('SearchImporterByProductSpecification') ||
        Get.isRegistered<SearchImporterByProductSpecificationController>();
    final isSearchExporterByProductSpecification =
        currentRoute.contains('SearchExporterByProductSpecification') ||
        Get.isRegistered<SearchExporterByProductSpecificationController>();

    final isAddFolder =
        currentRoute.contains('AddFolder') ||
        Get.isRegistered<AddFolderController>();
    final isTextileExporters =
        currentRoute.contains('TextileExporters') ||
        Get.isRegistered<TextileExportersController>();
    final isSearchExportersByCities =
        currentRoute.contains('SearchExportersByCities') ||
        Get.isRegistered<SearchExportersByCitiesController>();

    final isUpdateData =
        currentRoute.contains('UpdateData') ||
        Get.isRegistered<UpdateDataController>();

    return Drawer(
      child: Container(
        color: const Color(0xFF2D7373),
        child: FutureBuilder<UserModel?>(
          future: LocalStorageService.getUserData(),
          builder: (context, snapshot) {
            // Default values
            String userName = 'ADMIN';
            String userEmail = 'admin@textile.com';
            UserModel? user = snapshot.data;

            // If data is loaded, use real user data
            if (snapshot.hasData && user != null) {
              userName = user.fullName.toUpperCase();
              userEmail = user.email;
            }

            // Helper: if we don't have user data yet, keep previous behaviour (show all)
            bool can(String code) =>
                user == null ? true : user.hasPermission(code);

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFF4A9B9B),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF4A9B9B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userEmail,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _DrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: isDashboard,
                  onTap: () {
                    Get.off(() => const Dashboard());
                    Get.back();
                  },
                ),
                if (can('1AB'))
                  _DrawerItem(
                    icon: Icons.business,
                    title: 'Textile Importers',
                    isSelected: isTextileImporters,
                    onTap: () {
                      Get.back();
                      Get.off(() => const TextileImporters());
                    },
                  ),
                if (can('1AB'))
                  _DrawerItem(
                    icon: Icons.people,
                    title: 'Buyers',
                    isSelected: isBuyers,
                    onTap: () {
                      Get.back();
                      Get.off(() => const Buyers());
                    },
                  ),
                if (can('9MDDB'))
                  _DrawerItem(
                    icon: Icons.checkroom,
                    title: 'Buyer Product Wise',
                    isSelected: isBuyerProductWise,
                    onTap: () {
                      Get.back();
                      Get.delete<BuyerProductWiseController>(force: true);
                      Get.off(() => const BuyerProductWise());
                    },
                  ),
                if (can('14GSK'))
                  _DrawerItem(
                    icon: Icons.checkroom,
                    title: 'Garment Socks Knitted',
                    isSelected: isGarmentSocksKnitted,
                    onTap: () {
                      Get.back();
                      Get.off(() => const GarmentSocksKnitted());
                    },
                  ),
                // No explicit code in sample for this screen – keep always visible
                _DrawerItem(
                  icon: Icons.search,
                  title: 'Search Garment Importer By Product Specification',
                  isSelected: isSearchGarmentImporter,
                  onTap: () {
                    Get.back();
                    Get.off(
                      () =>
                          const SearchGarmentImporterByProductSpecification(),
                    );
                  },
                ),
                if (can('15GD'))
                  _DrawerItem(
                    icon: Icons.inventory,
                    title: 'Garment Denim',
                    isSelected: isGarmentDanim,
                    onTap: () {
                      Get.back();
                      Get.off(() => const GarmentDenim());
                    },
                  ),
                // No dedicated permission code known, keep visible
                _DrawerItem(
                  icon: Icons.search,
                  title: 'Search Denim Importer By Product Specification',
                  isSelected: isSearchDanim,
                  onTap: () {
                    Get.back();
                    Get.off(() => const SearchDanim());
                  },
                ),
                if (can('6EML'))
                  _DrawerItem(
                    icon: Icons.email,
                    title: 'Email Importers City Wise',
                    isSelected: isEmailImportersCityWise,
                    onTap: () {
                      Get.back();
                      Get.off(() => const EmailImportersCityWise());
                    },
                  ),
                if (can('6EML'))
                  _DrawerItem(
                    icon: Icons.flag,
                    title: 'Email Importers Country Wise',
                    isSelected: isEmailImportersCountryWise,
                    onTap: () {
                      Get.back();
                      Get.off(() => const EmailImportersCountryWise());
                    },
                  ),
                if (can('4MPS'))
                  _DrawerItem(
                    icon: Icons.map,
                    title: 'Importers on Google Map',
                    onTap: () => Get.back(),
                  ),
                if (can('9MDDB'))
                  _DrawerItem(
                    icon: Icons.category,
                    title: 'Search Importer By Product Specification',
                    isSelected: isSearchImporterByProductSpecification,
                    onTap: () {
                      Get.back();
                      Get.off(
                        () =>
                            const SearchImporterByProductSpecification(),
                      );
                    },
                  ),
                if (can('7MB'))
                  _DrawerItem(
                    icon: Icons.folder,
                    title: 'My Folders',
                    isSelected: isAddFolder,
                    onTap: () {
                      Get.back();
                      Get.off(() => const AddFolderScreen());
                    },
                  ),
                const Divider(color: Colors.white24, height: 1),
                if (can('8SP'))
                  _DrawerItem(
                    icon: Icons.business_center,
                    title: 'Textile Exporters',
                    isSelected: isTextileExporters,
                    onTap: () {
                      Get.back();
                      Get.off(() => const TextileExporters());
                    },
                  ),
                if (can('5CTS'))
                  _DrawerItem(
                    icon: Icons.location_city,
                    title: 'Search Exporters by Cities',
                    isSelected: isSearchExportersByCities,
                    onTap: () {
                      Get.back();
                      Get.off(() => const SearchExportersByCities());
                    },
                  ),
                if (can('7MB'))
                  _DrawerItem(
                    icon: Icons.folder_outlined,
                    title: 'My Folders',
                    onTap: () => Get.back(),
                  ),
                if (can('10CYFDB'))
                  _DrawerItem(
                    icon: Icons.search_outlined,
                    title: 'Search Exporter By Product Specification',
                    isSelected: isSearchExporterByProductSpecification,
                    onTap: () {
                      Get.back();
                      Get.off(
                        () =>
                            const SearchExporterByProductSpecification(),
                      );
                    },
                  ),
                if (can('13DATA'))
                  _DrawerItem(
                    icon: Icons.update,
                    title: 'Update Data',
                    isSelected: isUpdateData,
                    onTap: () {
                      Get.back();
                      Get.off(() => const UpdateData());
                    },
                  ),
                _DrawerItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () {
                    Get.back();
                    Get.off(() => const LoginPage());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? const Color(0xFF4A9B9B) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}
