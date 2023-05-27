import 'dart:developer';
import 'package:construction_company/dash.dart';
import 'package:construction_company/home.dart';
import 'package:construction_company/home.dart';
import 'package:construction_company/special_pages/Map.dart';
import 'package:construction_company/special_pages/equipmentDetails.dart';
import 'package:construction_company/special_pages/equipment.dart';
import 'package:construction_company/special_pages/addProject.dart';
import 'package:construction_company/special_pages/projectOverview.dart';
import 'package:construction_company/signup.dart';
import 'package:construction_company/special_pages/projectdetailsScreen.dart';
import 'package:construction_company/special_pages/workers.dart';
import 'package:construction_company/widget/equipment/equipmentScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'special_pages/notification.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString('email');
  runApp(
    MaterialApp(
      home: email == null ? Login(name: 'name') : Home(),
      debugShowCheckedModeBanner: false,
    ),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      
    );
    
    
  }
}
