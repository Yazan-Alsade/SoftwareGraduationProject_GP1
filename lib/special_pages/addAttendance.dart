import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AttendanceFormPage extends StatefulWidget {
  final String workerId;
  final String workerName;

  AttendanceFormPage({required this.workerId, required this.workerName});

  @override
  _AttendanceFormPageState createState() => _AttendanceFormPageState();
}

class _AttendanceFormPageState extends State<AttendanceFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPresent = false;
  TextEditingController _dateController = TextEditingController();
  String _errorMessage = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> submitAttendance() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      Map<String, dynamic> map = {
        "workerId": widget.workerId,
        "date": _dateController.text.toString().trim(),
        "present": _isPresent,
      };
      var body = json.encode(map);
      var encoding = Encoding.getByName('utf-8');
      const headers = {"Content-Type": "application/json"};
      var res = await http.post(
        Uri.parse('http://10.0.2.2:3000/Worker/AddAttendance'),
        headers: headers,
        body: body,
        encoding: encoding,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (res.statusCode == 200) {
        final responsedata = jsonDecode(res.body);
        final userId = responsedata['attendance'];
        final existingDateAdded = responsedata['existingAttendance'];

        if (existingDateAdded!=null&&existingDateAdded) {
          Fluttertoast.showToast(
            msg: 'Attendance for this date already exists',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Attendance has been added successfully.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xFF336699),
            textColor: Colors.white,
          );
        }
      } else {
        final responsedata = jsonDecode(res.body);
        Fluttertoast.showToast(
          msg: responsedata['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF336699),
        title: Text(
          'Attendance Form',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance for ${widget.workerName}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF336699),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Select Attendance:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF336699),
                    ),
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isPresent,
                        onChanged: (value) {
                          setState(() {
                            _isPresent = value!;
                          });
                        },
                        activeColor:
                            Color(0xFF336699), // Set radio button color
                      ),
                      Text('Present'),
                      SizedBox(width: 16.0),
                      Radio<bool>(
                        value: false,
                        groupValue: _isPresent,
                        onChanged: (value) {
                          setState(() {
                            _isPresent = value!;
                          });
                        },
                        activeColor:
                            Color(0xFF336699), // Set radio button color
                      ),
                      Text('Absent'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : submitAttendance,
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF336699),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
