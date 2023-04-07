import 'package:flutter/material.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logout"),
      ),
      body: Center(
        child: Text("Logout",style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
