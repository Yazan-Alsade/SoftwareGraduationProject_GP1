import 'package:construction_company/special_pages/itemsEquipment.dart';
import 'package:construction_company/widget/equipment/appBarEquip.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Equipment extends StatefulWidget {
  const Equipment({Key? key}) : super(key: key);

  @override
  State<Equipment> createState() => _EquipmentState();
}

class _EquipmentState extends State<Equipment> {
//////////////// For all categories
  Future<List<dynamic>> getCategories() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/Materials/Category'));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['categories'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // List<dynamic> materials = [];
  // @override
  // void initState() {
  //   super.initState();
  //   fetchMaterials();
  // }

  //////////// For all materials
  // Future<List<dynamic>> fetchMaterials() async {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('http://10.0.2.2:3000/Materials/GetAllMaterial'));
  //     final data = jsonDecode(response.body);
  //     setState(() {
  //       return data['ShowMaterial'];
  //     });
  //   } catch (error) {
  //     print('Error fetching materials: $error');
  //   }
  // }
  Future<List<dynamic>> fetchMaterial() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/Materials/GetAllMaterial'));
    print(response.statusCode);
    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded['ShowMaterial'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  List<String> items = [
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
    "images/istockphoto-1288941637-612x612.jpg",
  ];
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
            "Categories of Equipment and Materials",
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal[400],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder(
            future: getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                var categories = snapshot.data as List<dynamic>;
                categories = categories.reversed.toList();

                return Container(
                  height: 140,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ItemsEquipment();
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xfff7b858),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 100,
                              child: Image.network(
                                category['imageUrl'],
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              category['name'],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Material and Equipment for you:",
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal[400],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          
          Container(
            height: 200,
            // width: 200,
            child: FutureBuilder(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  var materials = snapshot.data as List<dynamic>;
                  materials = materials.reversed.toList();

                  return ScrollSnapList(
                    dynamicItemSize: true,
                    itemSize: 150,
                    itemBuilder: (context, index) {
                      var material = materials[index];

                      return Card(
                        elevation: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Column(
                            children: [
                              Image.network(
                                material['imageUrl'],
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                material["name"],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(
                                    //   "\$${material['price']}",
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // Text(
                                    //   material['unit'],
                                    //   style: TextStyle(color: Colors.blue),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: materials.length,
                    onItemFocus: (index) {
                      // do something when item is focused
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildListItem(BuildContext context, int index) {
  //    FutureBuilder(
  //     future: fetchMaterial(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       } else {
  //         var materials = snapshot.data as List<dynamic>;
  //         materials = materials.reversed.toList();

  //         return ScrollSnapList(
  //           itemSize: 300,
  //           itemBuilder: (context, index) {
  //             var material = materials[index];

  //             return Card(
  //               elevation: 12,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 child: Column(
  //                   children: [
  //                     Image.network(
  //                       material['media'],
  //                       fit: BoxFit.cover,
  //                       height: 200,
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       material["name"],
  //                       style: TextStyle(
  //                         fontSize: 15,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             "\$${material['price']}",
  //                             style: TextStyle(fontWeight: FontWeight.bold),
  //                           ),
  //                           Text(
  //                             material['unit'],
  //                             style: TextStyle(color: Colors.blue),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //           itemCount: materials.length,
  //           onItemFocus: (int index) {
  //             // do something when item is focused
  //           },
  //         );
  //       }
  //     },
  //   );
  // }
}
