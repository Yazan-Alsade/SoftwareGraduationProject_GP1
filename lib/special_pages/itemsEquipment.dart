import 'package:flutter/material.dart';

import '../widget/equipment/appBarEquip.dart';

class ItemsEquipment extends StatefulWidget {
  const ItemsEquipment({super.key});

  @override
  State<ItemsEquipment> createState() => _ItemsEquipmentState();
}

class _ItemsEquipmentState extends State<ItemsEquipment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBarEquipmentAndMaterial(
            titleAppBar: "Find Equipment",
            onPressedIcon: () {},
            onPressedSearch: () {},
          ),
    );
  }
}