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
    
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TextileImportersController());

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const impotersListPage(),
    );
  }
}