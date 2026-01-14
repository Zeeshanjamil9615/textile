import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/garment_socks_knitted/garment_socks_knitted_controller.dart';
import 'package:textile/views/drawer/garment_socks_knitted/list_pages.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class GarmentSocksKnitted extends StatelessWidget {
  const GarmentSocksKnitted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GarmentSocksKnittedController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const GarmentSocksKnittedListPage(),
    );
  }
}