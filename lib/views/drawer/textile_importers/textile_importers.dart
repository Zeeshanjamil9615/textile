import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/textile_importers/list_pages.dart';
import 'package:textile/views/drawer/textile_importers/textile_importers_controller.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class TextileImporters extends StatefulWidget {
  const TextileImporters({Key? key}) : super(key: key);

  @override
  State<TextileImporters> createState() => _TextileImportersState();
}

class _TextileImportersState extends State<TextileImporters> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(TextileImportersController());
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
    final controller = Get.find<TextileImportersController>();

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const impotersListPage(),
    );
  }
}