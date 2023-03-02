import 'package:construction_company/clipper.dart';
import 'package:construction_company/clipper2.dart';
import 'package:construction_company/login.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 100),
                painter: RPSCustomPainter(),
              ),
              Positioned(
                  top: 16,
                  right: -5,
                  child: CustomPaint(
                    size: Size(
                      MediaQuery.of(context).size.width,
                      110,
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
                  'Sign Up',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Please Sign up to continue.',
                  style: TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 141, 140, 140)),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 8,
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        // contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 141, 140, 140)),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                  height: 10,
                ),
                Card(
                  elevation: 8,
                  child: TextFormField(
                    obscureText: true,
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
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 8,
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        // contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter your confirm password',
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
              // margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.all(20),
              // alignment: AlignmentDirectional.topCenter,
              height: 59,
              width: 150,
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
                        'SIGN UP',
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
            margin: EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have account?',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Login();
                    }));
                  },
                  child: Text(
                    'Sign in',
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
