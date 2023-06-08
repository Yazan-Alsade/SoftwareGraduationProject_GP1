import 'package:construction_company/special_pages/equipmentDetails.dart';
import 'package:construction_company/special_pages/materialInCategory.dart';
import 'package:construction_company/widget/equipment/appBarEquip.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'const.dart';

class Equipment extends StatefulWidget {
  const Equipment({Key? key}) : super(key: key);

  @override
  State<Equipment> createState() => _EquipmentState();
}

class _EquipmentState extends State<Equipment> {
  String _searchTerm = '';

//////////////// For get all categories
  Future<List<dynamic>> getCategories() async {
    final response =
        await http.get(Uri.parse('$apiBaseUrl:3000/Materials/Category'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // return decoded['categories'];
      final categories = decoded['categories'] as List<dynamic>;

      // Filter categories based on search term
      final filteredCategories = categories
          .where((category) => category['name']
              .toLowerCase()
              .contains(_searchTerm.toLowerCase()))
          .toList();

      return filteredCategories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

/////////////// for get all material
  Future<List<dynamic>> fetchMaterial() async {
    final response = await http
        .get(Uri.parse('$apiBaseUrl:3000/Materials/GetAllMaterial'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // return decoded['materials'];
      final materials = decoded['materials'] as List<dynamic>;

      // Filter materials based on search term
      final filteredMaterials = materials
          .where((material) =>
              material['name']
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase()) ||
              material['category']
                  .toLowerCase()
                  .contains(_searchTerm.toLowerCase()))
          .toList();

      return filteredMaterials;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.search)),
                      hintText: "Find Category or Material",
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 60,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: 30,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // appBarEquipmentAndMaterial(
          //   titleAppBar: "Find Equipment",
          //   onPressedIcon: () {},
          //   onPressedSearch: () {},
          // ),
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
                    separatorBuilder: (context, index) => SizedBox(width: 20),
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ItemsEquipment(
                              categoryName: category['name'],
                            );
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // color: Color(0xfff7b858),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 50,
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
            "Material and Equipment in my Company:",
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
            child: FutureBuilder(
              future: fetchMaterial(),
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
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MaterialDetailsDialog(material: material,);
                            },
                          );
                        },
                        child: Card(
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
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text(
                                    material["name"],
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${material['price']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        material['unit'],
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
                    },
                    scrollDirection: Axis.horizontal,
                    initialIndex: 0,
                    itemCount: materials.length,
                    onItemFocus: (index) {},
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
