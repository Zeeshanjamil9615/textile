import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/Search_Exporter_By_Product_Specification_controller.dart';
import 'package:textile/views/drawer/Search_Exporter_By_Product_Specification/list_pages.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class SearchExporterByProductSpecification extends StatelessWidget {
  const SearchExporterByProductSpecification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchExporterByProductSpecificationController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const SearchExporterByProductSpecificationListPage(),
    );
  }
}