import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/buyers/buyer_controller.dart';
import 'package:textile/views/drawer/buyers/list_pages.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class Buyers extends StatelessWidget {
  const Buyers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyersController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const BuyersListPage(),
    );
  }
}