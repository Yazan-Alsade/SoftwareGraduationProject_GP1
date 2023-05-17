import 'home.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> forms = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isVisibility = false;
  bool _isVisibility2 = false;

  bool isloading = false; // for loading
  bool emailExist = false; // for check email

  //validation
  var emailaddress;
  var usernamee;
  var passwordd;
  var confirmp;
  var birthdate;
  var balance;

  // controller
  TextEditingController _date = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _balance = TextEditingController();
  var country;
///////////// for Create Account //////////////
  insert() async {
    if (forms.currentState!.validate()) {
      isloading = true;
      setState(() {});
      // await Future.delayed(Duration(seconds: 2));
      Map<String, dynamic> map = {
        "name": _username.text.toString().trim(),
        "email": _email.text.toString().trim(),
        "password": _password.text.toString().trim(),
        "confirmPassword": _confirmPassword.text.toString().trim(),
        "age": _date.text.toString().trim(),
        "country": country.toString().trim(),
        "balance": _balance.text.toString().trim(),
      };
      var body = json.encode(map);
      var encoding = Encoding.getByName('utf-8');
      const headers = {"Content-Type": "application/json"};
      var res = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/v1/auth/signup'),
          headers: headers,
          body: body,
          encoding: encoding);

      setState(() {
        isloading = false;
      });
      if (res.statusCode == 201) {
        final responsedata = jsonDecode(res.body);
        final userId = responsedata['savedUser'];
        Fluttertoast.showToast(
            msg: 'Signup Successful ! Please verify your email',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        final responsedata = jsonDecode(res.body);
        Fluttertoast.showToast(
            msg: responsedata['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    }
  }
  ///////////////// Create Account /////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Create Your Account",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      // resizeToAvoidBottomInset: false,
      body: isloading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    alignment: AlignmentDirectional.bottomStart,
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please Sign up to continue.',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 141, 140, 140)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: forms,
                          child: Container(
                            child: Column(
                              children: [
                                // elevation: 8,
                                Card(
                                  elevation: 8,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your username';
                                      } else if (value.length < 4) {
                                        return 'Username must be at least 4 characters long';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        usernamee = value;
                                      });
                                    },
                                    controller: _username,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person_2_outlined,
                                          color: (Color(0xfff7b858)),
                                        ),
                                        // contentPadding: EdgeInsets.all(10),
                                        hintText: 'Enter your name',
                                        hintStyle: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 141, 140, 140)),
                                        border: InputBorder.none),
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),
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
                                        emailaddress = value;
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
                                            color: Color.fromARGB(
                                                255, 141, 140, 140)),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
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
                                        passwordd = value;
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
                                          color:
                                              Color.fromARGB(255, 155, 130, 93),
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 141, 140, 140)),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  elevation: 8,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (value != passwordd) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        confirmp = value;
                                      });
                                    },
                                    controller: _confirmPassword,
                                    obscureText: !_isVisibility2,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,
                                          color: (Color(0xfff7b858)),
                                        ),
                                        // contentPadding: EdgeInsets.all(10),
                                        hintText: 'Enter confirm password',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isVisibility2 = !_isVisibility2;
                                            });
                                          },
                                          icon: _isVisibility2
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off),
                                          color:
                                              Color.fromARGB(255, 155, 130, 93),
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 141, 140, 140)),
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
                                        return 'Please enter your balance';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        balance = value;
                                      });
                                    },
                                    controller: _balance,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.attach_money_rounded,
                                          color: (Color(0xfff7b858)),
                                        ),
                                        // contentPadding: EdgeInsets.all(10),
                                        hintText: 'Enter your balance',
                                        hintStyle: TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 141, 140, 140)),
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
                                        return 'Please enter your date of birth';
                                      } else {
                                        try {
                                          birthdate = DateTime.parse(value);
                                          return null;
                                        } catch (e) {
                                          return 'Please enter a valid date (YYYY-MM-DD)';
                                        }
                                      }
                                    },
                                    controller: _date,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.calendar_today_rounded,
                                        color: Color(0xfff7b858),
                                      ),
                                      labelText: "Select Date",
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 141, 140, 140),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onTap: () async {
                                      DateTime? pickeddate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101));
                                      if (pickeddate != null) {
                                        setState(() {
                                          _date.text = DateFormat('yyyy-MM-dd')
                                              .format(pickeddate);
                                        });
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Card(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      // elevation: 8,
                                      child: DropdownButtonFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                        // dropdownColor: Color(0xfff7b858),
                                        isExpanded: true,
                                        hint: Text(
                                          "Choose Country From Here",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        items: [
                                          "Jenin",
                                          "Nablus",
                                          "Ramallah",
                                          "Jerusalem",
                                          "Jericho",
                                          "Salfit"
                                        ]
                                            .map((e) => DropdownMenuItem(
                                                  child: Text(
                                                    "$e",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 155, 130, 93),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  value: e,
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            // print("$country");
                                            country = val!;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'please select an option';
                                          }
                                          return null;
                                        },
                                        value: country,
                                      )),
                                ),
                              ],
                            ),
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
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
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
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                await insert();
                              },

                              // if (forms.currentState!.validate()) {
                              // }

                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
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
                              image:
                                  AssetImage('images/Google_Icons-09-512.jpg')),
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
                            image:
                                AssetImage('images/Twitter-Logo-700x394.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 14, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have account?',
                          style: TextStyle(fontSize: 18),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 221, 163, 76),
                                fontSize: 20),
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
