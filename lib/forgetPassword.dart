import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'resetPassword.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  GlobalKey<FormState> forms = new GlobalKey();

  TextEditingController _emailController = TextEditingController();

  Future<void> sendResetPasswordEmail() async {
    String email = _emailController.text.trim();

    if (email.isNotEmpty) {
      var requestBody = json.encode({"email": email});
      var response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/v1/auth/forgetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Email sent successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Email Sent'),
              content: Text('An email has been sent to reset your password.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPasswordPage();
                    }));
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error sending email
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to send reset password email.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Check Email",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.all(20),
          alignment: AlignmentDirectional.bottomStart,
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Please Check Email to continue.',
                style: TextStyle(
                    fontSize: 17, color: Color.fromARGB(255, 141, 140, 140)),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          controller: _emailController,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
       
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color(0xfff7b858)),
          width: 240,
          // color: Color(0xfff7b858),
          child: TextButton(
            onPressed: () {
              sendResetPasswordEmail();
            },
            child: Text(
              'Check',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                // backgroundColor: Color(0xfff7b858),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ])),
      // ],
    );
    // ),
    // );
  }
}
