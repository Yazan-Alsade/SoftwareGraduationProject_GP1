import 'package:flutter/material.dart';

class notifications extends StatefulWidget {
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notifications"),
      ),
      body: Center(
        child: Text("notifications",style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
