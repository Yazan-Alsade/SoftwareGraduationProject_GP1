import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widget/equipment/appBarEquip.dart';

class ItemsEquipment extends StatefulWidget {
  const ItemsEquipment({
    super.key,
  });

  @override
  State<ItemsEquipment> createState() => _ItemsEquipmentState();
}

class _ItemsEquipmentState extends State<ItemsEquipment> {
  Future<List<dynamic>> getCategories() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/Materials/Category'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['categories'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            appBarEquipmentAndMaterial(
              titleAppBar: "Find Equipment",
              onPressedIcon: () {},
              onPressedSearch: () {},
            ),
            SizedBox(
              height: 20,
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
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Color(0xfff7b858),
                              //     borderRadius: BorderRadius.circular(20),
                              //   ),
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   height: 100,
                              //   child: Image.network(
                              //     category['imageUrl'],
                              //     height: 100,
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
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
          ],
        ),
      ),
    );
  }
}
