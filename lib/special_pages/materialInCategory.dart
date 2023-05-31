import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widget/equipment/appBarEquip.dart';
import 'materialcomp.dart';

class ItemsEquipment extends StatefulWidget {
  final String categoryName;
  const ItemsEquipment({
    super.key,
    required this.categoryName,
  });

  @override
  State<ItemsEquipment> createState() => _ItemsEquipmentState();
}

class _ItemsEquipmentState extends State<ItemsEquipment> {
  List<dynamic> _filteredMaterials = [];
  String _searchTerm = '';
  List<dynamic> _cartItems = [];

  /////////
  void _addToCart(dynamic material) {
    setState(() {
      _cartItems.add(material);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Item Added To Cart')));
  }

  void _navigateToShoppingCart() async {
    final deletedIndex = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingCartPage(
          cartItems: _cartItems,
        ),
      ),
    );

    if (deletedIndex != null) {
      setState(() {
        _cartItems.removeAt(deletedIndex); // Remove the item from the cart
      });
    }
  }

  ////////
  Future<List<dynamic>> getmaterial() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/Materials/${widget.categoryName}'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final materials = decoded['materials'];
      if (_searchTerm.isEmpty) {
        return materials;
      } else {
        final filteredMaterials = materials.where((material) => material['name']
            .toString()
            .toLowerCase()
            .contains(_searchTerm.toLowerCase()));
        return filteredMaterials.toList();
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  /////////// For similarity

  Future<List<dynamic>> getRecommendedMaterials(String materialId) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3000/Recommandation/Recomandation/$materialId'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final recommendedMaterials = decoded['recommendedMaterials'];
      return recommendedMaterials;
    } else {
      throw Exception('Failed to load recommended materials');
    }
  }

  void _showRecommendedMaterialsDialog(dynamic material) async {
    final recommendedMaterials = await getRecommendedMaterials(material['_id']);
    if (recommendedMaterials.isEmpty) {
      final materials = await getmaterial();
      if (materials.length == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'No recommendations for ${material['name']}',
                style: TextStyle(fontSize: 15),
              ),
              content: Text('There are no recommendations for this material.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
        return;
      } else {
        Navigator.of(context).pop();
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Recommended Materials for ${widget.categoryName}',
            style: TextStyle(fontSize: 15),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recommendedMaterials.length,
              itemBuilder: (BuildContext context, int index) {
                final recommendedMaterial = recommendedMaterials[index];
                return Card(
                  color: Colors.grey[200],
                  // elevation: 6,
                  child: Container(
                    child: Column(
                      children: [
                        Image.network(
                          recommendedMaterial['imageUrl'],
                          width: 100,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            recommendedMaterial['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                  'Description: ${recommendedMaterial['description']}'),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  'Price: ${recommendedMaterial['price']}',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
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
                        hintText: "Find Material for ${widget.categoryName}",
                        hintStyle: TextStyle(fontSize: 15),
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
                      borderRadius: BorderRadius.circular(30),
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
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 60,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: IconButton(
                      onPressed: () {
                        _navigateToShoppingCart();
                      },
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: Colors.grey[600],
                          ),
                          if (_cartItems.isNotEmpty)
                            Positioned(
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                      minWidth: 12, maxHeight: 12),
                                  child: Text(
                                    _cartItems.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Category Name: ${widget.categoryName}',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getmaterial(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error:${snapshot.error}');
                    } else {
                      var materialss = snapshot.data as List<dynamic>;
                      if (materialss.isEmpty) {
                        return Center(
                            child: Text(
                          "No Material Found",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold),
                        ));
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final material = materialss[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                _showRecommendedMaterialsDialog(material);
                              },
                              child: Card(
                                color: Colors.grey[200],
                                elevation: 4,
                                child: ListTile(
                                  title: Container(
                                    child: Column(children: [
                                      Container(
                                        child:
                                            Image.network(material['imageUrl']),
                                        width: 150,
                                      ),
                                      Text(
                                        'Material Name: ${material['name']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          'Description: ${material['description']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        'Price: ${'\$${material['price']}'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.teal),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text(
                                          'Stock Available: ${'${material['stock']}'}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.teal),
                                        ),
                                      ),
                                      // 
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: Color(0xfff7b858),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TextButton(
                                            onPressed: () {
                                              _addToCart(material);
                                            },
                                            child: Text(
                                              "Add to Cart",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: materialss.length,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
