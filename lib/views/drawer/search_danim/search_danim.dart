import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/views/drawer/search_danim/list_pages.dart';
import 'package:textile/views/drawer/search_danim/search_danim_controller.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class SearchDanim extends StatelessWidget {
  const SearchDanim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchDanimController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const SearchdanimListPage(),
    );
  }
}