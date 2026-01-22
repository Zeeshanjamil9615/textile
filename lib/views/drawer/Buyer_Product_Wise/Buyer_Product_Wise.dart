import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/Buyer_Product_Wise_controller.dart';
import 'package:textile/views/drawer/Buyer_Product_Wise/list_pages.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class BuyerProductWise extends StatelessWidget {
  const BuyerProductWise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyerProductWiseController());

    return Scaffold(
      key: controller.scaffoldKey,
       appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
      drawer: const CustomDrawer(),
      body: const buyerproductwiseListPage(),
    );
  }
}