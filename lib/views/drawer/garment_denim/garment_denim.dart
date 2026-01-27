import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/garment_denim/garment_denim_controller.dart';
import 'package:textile/views/drawer/garment_denim/list_pages.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class GarmentDenim extends StatefulWidget {
  const GarmentDenim({Key? key}) : super(key: key);

  @override
  State<GarmentDenim> createState() => _GarmentDenimState();
}

class _GarmentDenimState extends State<GarmentDenim> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(GarmentDenimController());
    // Auto-open filter section after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && controller.shouldAutoOpenFilter.value) {
        controller.shouldAutoOpenFilter.value = false;
        controller.showFilterBottomSheet(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GarmentDenimController>();

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const GarmnetDENIMListPage(),
    );
  }
}