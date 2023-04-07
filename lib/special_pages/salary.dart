import 'package:flutter/material.dart';

class Salary extends StatefulWidget {
  @override
  _SalaryState createState() => _SalaryState();
}

class _SalaryState extends State<Salary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salary"),
      ),
      body: Center(
        child: Text("Salary",style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
