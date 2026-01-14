import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/garment_denim/garment_denim_controller.dart';
import 'package:textile/views/drawer/garment_denim/list_pages.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class GarmentDenim extends StatelessWidget {
  const GarmentDenim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GarmentDenimController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const GarmnetDENIMListPage(),
    );
  }
}