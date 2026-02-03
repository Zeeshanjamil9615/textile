import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/Search_Exporters_by_Cities_controller.dart';
import 'package:textile/views/drawer/Search_Exporters_by_Cities/list_pages.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class SearchExportersByCities extends StatelessWidget {
  const SearchExportersByCities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchExportersByCitiesController());

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: const searchExportersByCitiesListPage(),
      ),
    );
  }
}