import 'package:construction_company/special_pages/itemsEquipment.dart';
import 'package:construction_company/widget/equipment/appBarEquip.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class Equipment extends StatefulWidget {
  const Equipment({Key? key}) : super(key: key);

  @override
  State<Equipment> createState() => _EquipmentState();
}

class _EquipmentState extends State<Equipment> {
  List<String> images = [
    "images/excavator (1).png",
    "images/excavator (1).png",
    "images/excavator (1).png",
    "images/excavator (1).png",
    "images/excavator (1).png",
  ];
  List<String> items = [
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
  ];

  List categories = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          appBarEquipmentAndMaterial(
            titleAppBar: "Find Equipment",
            onPressedIcon: () {},
            onPressedSearch: () {},
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "A Summer Surprise",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Cashback 20%",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ]),
                  ),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xfff7b858),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(160),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Categories of Equipment",
            style: TextStyle(
                fontSize: 18,
                color: Colors.teal[400],
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "images/istockphoto-1288941637-612x612.jpg",
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 17,
                        left: 30,
                        child: Text(
                          "Card with splash",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Equipment for you:",
            style: TextStyle(
                fontSize: 18,
                color: Colors.teal[400],
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 200,
              child: ScrollSnapList(
                itemBuilder: _buildListItem,
                itemCount: items.length,
                itemSize: 150,
                onItemFocus: (index) {},
                dynamicItemSize: true,
              )),
          SizedBox(
            height: 15,
          ),
          Text(
            "Categories of Material",
            style: TextStyle(
                fontSize: 18,
                color: Colors.teal[400],
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 150,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "images/istockphoto-1288941637-612x612.jpg",
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 17,
                        left: 30,
                        child: Text(
                          "Card with splash",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Material for you:",
            style: TextStyle(
                fontSize: 18,
                color: Colors.teal[400],
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 200,
              child: ScrollSnapList(
                itemBuilder: _buildListItem,
                itemCount: items.length,
                itemSize: 150,
                onItemFocus: (index) {},
                dynamicItemSize: true,
              )),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            children: [
              Image.asset(
                items[index],
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Excavtor",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1900",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Review",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
