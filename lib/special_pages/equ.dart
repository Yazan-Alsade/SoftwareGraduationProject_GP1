
import 'package:badges/badges.dart' as badges;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class equipment extends StatefulWidget {
  const equipment({Key? key}) : super(key: key);

  @override
  _equipmentState createState() => _equipmentState();
}

class _equipmentState extends State<equipment> {
  List<dynamic> _equipmentList = [];

  Future<void> _getEquipmentList() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/Equipment/GetEquipment'));
      if (response.statusCode == 200) {
        setState(() {
          _equipmentList = jsonDecode(response.body);
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (err) {
      print('Request failed with error: $err.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getEquipmentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      // AppBar(
      //   backgroundColor: Color(0xfff7b858),
      //   title: Text('Equipment List'),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            // height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 10)
                ]),
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(0, 0),
                            blurRadius: 8)
                      ]),
                  child: TextField(
                    autofocus: false,
                    onSubmitted: (value) {},
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.6), blurRadius: 8)
                      ]),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                badges.Badge(
                  badgeContent: Text(
                    "1",
                    style: TextStyle(color: Colors.white),
                  ),
                  badgeStyle: badges.BadgeStyle(badgeColor: Color(0xfff7b858)),
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              blurRadius: 8)
                        ]),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.shopping_cart_sharp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _equipmentList.length,
              itemBuilder: (context, index) {
                final equipment = _equipmentList[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "images/istockphoto-1323030556-612x612.jpg",
                          // equipment['media']??''
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Name : ${equipment['name'] ?? ''}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('Category : ${equipment['category'] ?? ''}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('Condition: ${equipment['specifications']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Availability: ${equipment['availabilityStatus'] ?? ''}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Location: ${equipment['location']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Maintenance History: ${equipment['maintenanceHistory'] ?? ''}',
                            // style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Notes : ${equipment['notes'] ?? ''}',
                            // style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Equipment Number: ${equipment['EquipmentNumber'].toString() ?? ''}',
                            // style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
