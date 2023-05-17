import 'package:construction_company/dash.dart';
import 'home.dart';
import 'signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:fluttertoast/fluttertoast.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> forms = new GlobalKey();

  bool _isVisibility = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool isloading = false;

  /////// Sign In ///////////

  void _handleLogin() async {
    final email = _email.text;
    final password = _password.text;

    // Validate form inputs
    if (forms.currentState!.validate()) {
      return;
    }

    // Send POST request to login API endpoint
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    // Handle response from API
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      // Save token to local storage or secure storage
      // ...

      // Navigate to home page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Home();
      }));
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];

      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Handle other error codes
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  ////////// For Sign In //////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Sign In",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(30),
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
                        fontSize: 17,
                        color: Color.fromARGB(255, 141, 140, 140)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 400,
                      height: 200,
                      // color: Colors.red,
                      child: Image.asset('images/pnh.png')),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: forms,
                    child: Container(
                      child: Column(
                        children: [
                          Card(
                            elevation: 8,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your email';
                                } else if (!RegExp(
                                        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                                    .hasMatch(value)) {
                                  return 'please enter a valid email address';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  var emailaddress = value;
                                });
                              },
                              controller: _email,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: (Color(0xfff7b858)),
                                  ),
                                  // contentPadding: EdgeInsets.all(10),
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 141, 140, 140)),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            elevation: 8,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  var passwordd = value;
                                });
                              },
                              controller: _password,
                              obscureText: !_isVisibility,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: (Color(0xfff7b858)),
                                  ),
                                  // contentPadding: EdgeInsets.all(10),
                                  hintText: 'Enter your password',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisibility = !_isVisibility;
                                      });
                                    },
                                    icon: _isVisibility
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    color: Color.fromARGB(255, 155, 130, 93),
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 141, 140, 140)),
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                // margin: EdgeInsets.only(left: 70),
                padding: EdgeInsets.all(20),
                // alignment: AlignmentDirectional.topCenter,
                height: 60,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (Color(0xfff7b858)),
                        blurRadius: 3,
                        // offset: Offset(2, 2),
                      ),
                      // color: (Color(0xfff7b858)),
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _handleLogin();
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
              margin: EdgeInsets.all(10),
              // color: Colors.red,
              // alignment: Alignment.center,
              width: 300,
              height: 60,
              padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     border: Border(
              //         bottom:
              //             BorderSide(color: (Color(0xfff7b858)), width: 1.5))),
              // margin: EdgeInsets.only(top: 20, bottom: 20),
              child: InkWell(
                onTap: () {},
                child: Text(
                  'Forget Password ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: (Color.fromARGB(255, 129, 100, 55)),
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Row(children: [
              Container(
                width: 150,
                child: Divider(
                  thickness: 1.2,
                  color: Color.fromARGB(255, 109, 87, 55),
                  indent: 15,
                  height: 50,
                  endIndent: 15,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Or Login with",
                style: TextStyle(
                    color: Color(0xfff7b858),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                width: 142,
                child: Divider(
                  thickness: 1.2,
                  color: Color.fromARGB(255, 109, 87, 55),
                  indent: 15,
                  endIndent: 15,
                  height: 50,
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  // color: Colors.red,
                  height: 50,
                  width: 50,
                  child: InkWell(
                    onTap: () {},
                    child: Image(
                        image: AssetImage('images/Google_Icons-09-512.jpg')),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  height: 35,
                  width: 35,
                  child: InkWell(
                    onTap: () {},
                    child: Image(
                      image: AssetImage('images/Facebook_Logo.jpg'),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  height: 50,
                  width: 50,
                  child: InkWell(
                    onTap: () {},
                    child: Image(
                      image: AssetImage('images/Twitter-Logo-700x394.png'),
                    ),
                  ),
                ),
              ],
            ),
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
                      style:
                          TextStyle(color: (Color(0xfff7b858)), fontSize: 19),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
