import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/textile_Exporters/list_pages.dart';
import 'package:textile/views/drawer/textile_Exporters/textile_Exporters_controller.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class TextileExporters extends StatelessWidget {
  const TextileExporters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextileExportersController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const ExportersListPage(),
    );
  }
}