import 'package:flutter/material.dart';

class MaterialCom extends StatefulWidget {
  @override
  _MaterialComState createState() => _MaterialComState();
}

class _MaterialComState extends State<MaterialCom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Material"),
      ),
      body: Center(
        child: Text(
          "Material",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
