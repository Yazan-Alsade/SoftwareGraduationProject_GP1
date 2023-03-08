import 'package:construction_company/app/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isVisibility = false;
  bool _isVisibility2 = false;
  TextEditingController _date = TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  // TextEditingController stateCountry = new TextEditingController();
  var country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  Card(
                    elevation: 8,
                    child: TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: (Color(0xfff7b858)),
                          ),
                          // contentPadding: EdgeInsets.all(10),
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 141, 140, 140)),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    elevation: 8,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: (Color(0xfff7b858)),
                          ),
                          // contentPadding: EdgeInsets.all(10),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 141, 140, 140)),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    elevation: 8,
                    child: TextFormField(
                      controller: password,
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
                              color: Color.fromARGB(255, 141, 140, 140)),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    elevation: 8,
                    child: TextFormField(
                      controller: confirmPassword,
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
                            color: Color.fromARGB(255, 155, 130, 93),
                          ),
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
                    child: TextField(
                      controller: _date,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today_rounded,
                          color: Color(0xfff7b858),
                        ),
                        labelText: "Select Date",
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 141, 140, 140),
                        ),
                        border: InputBorder.none,
                      ),
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        if (pickeddate != null) {
                          setState(() {
                            _date.text =
                                DateFormat('yyyy-MM-dd').format(pickeddate);
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
                        child: DropdownButton(
                          // dropdownColor: Color(0xfff7b858),
                          underline: Divider(
                            thickness: 0,
                          ),
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
                                          color:
                                              Color.fromARGB(255, 155, 130, 93),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
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
                          value: country,
                        )),
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
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
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
