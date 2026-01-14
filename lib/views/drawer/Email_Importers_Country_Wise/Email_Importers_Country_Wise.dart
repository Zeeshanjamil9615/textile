import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Email_Importers_Country_Wise/Email_Importers_Country_Wise_controller.dart';
import 'package:textile/views/drawer/Email_Importers_Country_Wise/list_pages.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class EmailImportersCountryWise extends StatelessWidget {
  const EmailImportersCountryWise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailImportersCountryWiseController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const CountrywiseListPage(),
    );
  }
}