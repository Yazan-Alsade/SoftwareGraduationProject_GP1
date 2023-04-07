import 'package:flutter/material.dart';

class WorkerDash extends StatefulWidget {
  @override
  _WorkerDashState createState() => _WorkerDashState();
}

class _WorkerDashState extends State<WorkerDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WorkerDash"),
      ),
      body: Center(
        child: Text("WorkerDash",style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
