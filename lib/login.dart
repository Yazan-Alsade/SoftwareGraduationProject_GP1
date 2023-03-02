import 'package:construction_company/clipper.dart';
import 'package:construction_company/clipper2.dart';
import 'package:construction_company/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 134),
                painter: RPSCustomPainter(),
              ),
              Positioned(
                  top: 16,
                  right: 0,
                  child: CustomPaint(
                    size: Size(
                      MediaQuery.of(context).size.width,
                      1000,
                    ),
                    painter: PSCustomPainter(),
                  )),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            alignment: AlignmentDirectional.bottomStart,
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Please Sign in to continue.',
                  style: TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 141, 140, 140)),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 8,
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        // contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 141, 140, 140)),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 8,
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        // contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 141, 140, 140)),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.orange, width: 1.5))),
            margin: EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () {},
              child: Text(
                'Forget Password',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Container(
              // margin: EdgeInsets.only(left: 70),
              padding: EdgeInsets.all(20),
              // alignment: AlignmentDirectional.topCenter,
              height: 60,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                    colors: [Color(0xfff7b858), Color(0xfffca148)]),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 25,
                    )
                  ])),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Do not have an account?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUp();
                    }));
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Colors.orange, fontSize: 17),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
