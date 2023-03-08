import 'package:construction_company/app/auth/login.dart';
import 'package:construction_company/app/auth/signup.dart';
import 'package:construction_company/app/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      home: SignUp(),
      routes: {
        'signup':(context) => SignUp(),
        'login':(context) => Login(),
        'home':(context) => HomePage(),
      },
    );
  }
}
