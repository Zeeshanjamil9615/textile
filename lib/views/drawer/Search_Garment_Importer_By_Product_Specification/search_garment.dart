import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Garment_Importer_By_Product_Specification/list_pages.dart';
import 'package:textile/views/drawer/Search_Garment_Importer_By_Product_Specification/search_garment_controller.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class SearchGarmentImporterByProductSpecification extends StatelessWidget {
  const SearchGarmentImporterByProductSpecification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchGarmentImporterByProductSpecificationController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const SearchGarmentImporterByProductSpecificationListPage(),
    );
  }
}