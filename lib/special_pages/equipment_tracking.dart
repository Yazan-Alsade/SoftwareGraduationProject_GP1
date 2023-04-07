import 'package:flutter/material.dart';
class equipment extends StatefulWidget {
  @override
  _equipmentState createState() => _equipmentState();
}

class _equipmentState extends State<equipment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipment"),
      ),
      body: Center(
        child: Text("Equipment",style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
