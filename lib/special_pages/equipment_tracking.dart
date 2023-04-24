import 'package:flutter/material.dart';

class Equipment {
  String name;
  String image;
  String description;
  bool isAvailable;

  Equipment({
    required this.name,
    required this.image,
    required this.description,
    required this.isAvailable,
  });
}

class equipment extends StatefulWidget {
  @override
  _equipmentState createState() => _equipmentState();
}

class _equipmentState extends State<equipment> {
  List<Equipment> equipmentList = [
    Equipment(
      name: 'Excavator',
      image: 'images/excavator.png',
      description:
          'A heavy construction equipment used for digging and earth-moving',
      isAvailable: true,
    ),
    Equipment(
      name: 'Bulldozer',
      image: 'images/bulldozer.png',
      description:
          'A powerful tractor equipped with a blade used for pushing large quantities of soil or rubble',
      isAvailable: false,
    ),
    Equipment(
      name: 'Crane',
      image: 'images/crane.png',
      description: 'A tall machine used for lifting and moving heavy objects',
      isAvailable: true,
    ),
  ];

  List<Equipment> cartList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartList),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: equipmentList.length,
        itemBuilder: (BuildContext context, int index) {
          final equipment = equipmentList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(equipment.image),
            ),
            title: Text(equipment.name),
            subtitle: Text(equipment.description),
            trailing: equipment.isAvailable
                ? SingleChildScrollView(
                  child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Add equipment to cart
                            setState(() {
                              cartList.add(equipment);
                            });
                            // Show a notification that the equipment is added to cart
                            final snackBar = SnackBar(
                              content: Text('Equipment added to cart!'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Text('Add to Cart'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.blue;
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.white;
                              },
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Sell equipment
                            setState(() {
                              equipmentList.remove(equipment);
                            });
                            // Show a notification that the equipment is sold
                            final snackBar = SnackBar(
                              content: Text('Equipment sold!'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: Text('Sell'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.red;
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.white;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                )
                : Text('Unavailable'),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Equipment> cartList;

  const CartPage(this.cartList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: cartList.isEmpty
          ? Center(
              child: Text('Your cart is empty.'),
            )
          : ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (BuildContext context, int index) {
                final equipment = cartList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(equipment.image),
                  ),
                  title: Text(equipment.name),
                  subtitle: Text(equipment.description),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Remove equipment from cart
                      // setState(() {
                      cartList.remove(equipment);
                      // });
                      // Show a notification that the equipment is removed from cart
                      final snackBar = SnackBar(
                        content: Text('Equipment removed from cart!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text('Remove'),
                  ),
                );
              },
            ),
    );
  }
}
