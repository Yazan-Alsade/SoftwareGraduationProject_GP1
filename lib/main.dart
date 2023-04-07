import 'dart:developer';
import 'package:construction_company/dash.dart';
import 'package:construction_company/home.dart';
import 'package:construction_company/home.dart';
import 'package:construction_company/special_pages/project_overview.dart';
import 'package:construction_company/signup.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'count.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ProjectScreen(),
      routes: {
        'home': (BuildContext context) => Home(),
      },
    );
  }
}
