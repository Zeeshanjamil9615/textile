import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Update_Data/list_pages.dart';
import 'package:textile/views/drawer/Update_Data/Update_Data_controller.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class UpdateData extends StatelessWidget {
  const UpdateData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateDataController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const updatedataListPage(),
    );
  }
}