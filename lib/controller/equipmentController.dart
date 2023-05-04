import 'package:construction_company/special_pages/equipment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class EquipmentController extends GetxController {
  changePage(int currentpage);
}

class EquipmentControllerImp extends EquipmentController {
  int currentpage = 0;
  List<Widget> listPage = [
    Equipment(),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Settings"),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Profile"),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("Cart"),
        ),
      ],
    ),
  ];

  List titleBottomBar = [
    "Home",
    "Settings",
    "Profile",
    "Cart",
  ];
  @override
  changePage(int i) {
    currentpage = i;
    update();
  }
}
