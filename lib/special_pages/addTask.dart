import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:construction_company/special_pages/workers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'const.dart';

class AddTaskPage extends StatefulWidget {
  final String workerId;

  const AddTaskPage({required this.workerId});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _rewardController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();

  insert() async {
    Map<String, dynamic> map = {
      "description": _descriptionController.text.trim(),
      "status": _statusController.text.trim(),
      "startTime": _startTimeController.text.trim(),
      "endTime": _endTimeController.text.trim(),
      "reward": _rewardController.text.trim(),
      "discount": _discountController.text.trim(), // corrected line
      "latitude": _latitudeController.text.trim(), // corrected line
      "longitude": _longitudeController.text.trim(), // corrected line
    };
    var body = json.encode(map);
    var encoding = Encoding.getByName('utf-8');
    const headers = {"Content-Type": "application/json"};
    var res = await http.post(
      Uri.parse('$apiBaseUrl:3000/Worker/AddTask/${widget.workerId}'),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    print(res.statusCode);
    if (res.statusCode == 201) {
      final responseData = jsonDecode(res.body);
      final task = responseData['task'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'The Task has been Created Successfully',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WorkersPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        title: Text('Add Worker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 70, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Please Add New Worker:',
                          textStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          // speed: Duration(milliseconds: 500),
                        )
                      ],
                    )),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Description', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description ';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _statusController,
                      decoration: InputDecoration(
                          labelText: 'Status', border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _startTimeController,
                      decoration: InputDecoration(
                          labelText: 'Start Time ', border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _endTimeController,
                      decoration: InputDecoration(
                          labelText: 'End Time', border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _rewardController,
                      decoration: InputDecoration(
                          labelText: 'Reward', border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _discountController,
                      decoration: InputDecoration(
                          labelText: 'Discount', border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(
                          labelText: 'Latitude', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Latitude';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                          labelText: 'Lagnitude', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Lagnitude';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xfff7b858),
                  ),
                  onPressed: () => insert(),
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
