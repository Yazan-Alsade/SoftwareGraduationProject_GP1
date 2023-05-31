import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    String email = _emailController.text.trim();
    String verificationCode = _verificationCodeController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (email.isNotEmpty &&
        verificationCode.isNotEmpty &&
        newPassword.isNotEmpty) {
      var requestBody = json.encode({
        "email": email,
        "verificationCode": verificationCode,
        "password": newPassword,
      });
      var response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/v1/auth/resetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Password reset successful
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Password Reset'),
              content: Text('Your password has been successfully reset.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Login(name: '');
                    }));
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error resetting password
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to reset password.'),
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
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Password'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _verificationCodeController,
//               decoration: InputDecoration(
//                 labelText: 'Verification Code',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _newPasswordController,
//               decoration: InputDecoration(
//                 labelText: 'New Password',
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               child: Text('Reset Password'),
//               onPressed: resetPassword,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
    return Scaffold(
      // key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Reset Password",
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
                    'Reset Password',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter The new password',
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 141, 140, 140)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    // key: forms,
                    child: Container(
                      child: Column(
                        children: [
                          // elevation: 8,
                          Card(
                            elevation: 8,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'Please enter your username';
                              //   } else if (value.length < 4) {
                              //     return 'Username must be at least 4 characters long';
                              //   }
                              //   return null;
                              // },
                              onChanged: (value) {
                                setState(() {});
                              },
                              controller: _verificationCodeController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.verified,
                                    color: (Color(0xfff7b858)),
                                  ),
                                  // contentPadding: EdgeInsets.all(10),
                                  hintText: 'Enter verification code',
                                  hintStyle: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 141, 140, 140)),
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
                                  // emailaddress = value;
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
                                      color:
                                          Color.fromARGB(255, 141, 140, 140)),
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
                                  return 'Please enter new password';
                                } else if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  // passwordd = value;
                                });
                              },
                              controller: _newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: (Color(0xfff7b858)),
                                  ),
                                  // contentPadding: EdgeInsets.all(10),
                                  hintText: 'Enter New password',
                                  // suffixIcon: IconButton(
                                  // onPressed: () {
                                  // setState(() {
                                  // _isVisibility = !_isVisibility;
                                  // });
                                  // },
                                  // icon: _isVisibility
                                  // ? Icon(Icons.visibility)
                                  // : Icon(Icons.visibility_off),
                                  // color:
                                  // Color.fromARGB(255, 155, 130, 93),
                                  // ),
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xfff7b858)),
              width: 240,
              // color: Color(0xfff7b858),
              child: TextButton(
                onPressed: () {
                  resetPassword();
                },
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    // backgroundColor: Color(0xfff7b858),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
