import 'package:construction_company/controller/equipmentController.dart';
import 'package:construction_company/widget/equipment/activeBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EquipmentScreen extends StatelessWidget {
  final bool active = false;

  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EquipmentControllerImp());
    return GetBuilder<EquipmentControllerImp>(
      builder: (controller) => Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xfff7b858),
          onPressed: () {},
          child: Icon(Icons.shopping_basket_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            children: [
              ...List.generate(
                  controller.listPage.length + 1,
                  ((index) => index == 2
                      ? const Spacer()
                      : ActiveBottomBar(
                          textbutton: controller
                              .titleBottomBar[index > 2 ? index - 1 : index],
                          onPressed: () {
                            controller
                                .changePage(index > 2 ? index - 1 : index);
                          },
                          icon: Icons.home,
                          active: controller.currentpage ==
                                  (index > 2 ? index - 1 : index)
                              ? true
                              : false,
                        ))),
            ],
          ),
        ),
        body: controller.listPage.elementAt(controller.currentpage),
      ),
    );
  }
}
