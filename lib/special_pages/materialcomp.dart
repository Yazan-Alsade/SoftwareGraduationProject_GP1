

import 'package:flutter/material.dart';

class ShoppingCartPage extends StatefulWidget {
  final List<dynamic> cartItems;

  const ShoppingCartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}


class _ShoppingCartPageState extends State<ShoppingCartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Text(
                      "Price",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "1200 \$",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Shopping",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "300 \$",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              // thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Text(
                      "Total Price",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "1500 \$",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[300],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(15),
              width: double.infinity,
              color: Color.fromARGB(214, 238, 151, 22),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          var item = widget.cartItems[index];
          return Container(
            padding: EdgeInsets.all(10),
            // margin: EdgeInsets.all(5),
            child: Card(
              elevation: 4,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Image.network(
                      item['imageUrl'],
                      width: 100,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Price: \$${item['price']}',
                          style: TextStyle(
                              color: Colors.red[300],
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context, index);
                          },
                        ),
                        Container(
                          child: Text(
                            "2",
                            style: TextStyle(),
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.remove))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Rest of the code
}
