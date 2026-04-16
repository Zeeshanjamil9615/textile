import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Exporter_Product_Wise/Exporter_Product_Wise_controller.dart';
import 'package:textile/views/drawer/Exporter_Product_Wise/category_grid_page.dart';
import 'package:textile/views/drawer/Exporter_Product_Wise/list_pages.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class ExporterProductWise extends StatelessWidget {
  const ExporterProductWise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExporterProductWiseController());

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(
        onMenuPressed: controller.openDrawer,
        showBack: controller.showList.value,
        onBackPressed: controller.backToCategories,
      ),
      drawer: const CustomDrawer(),
      body: Obx(
        () => controller.showList.value
            ? const ExporterproductwiseListPage()
            : const ExporterProductWiseCategoryGridPage(),
      ),
    );
  }
}