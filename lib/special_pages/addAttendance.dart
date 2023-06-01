import 'package:flutter/material.dart';
import 'package:construction_company/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AttendanceFormPage extends StatefulWidget {
  final String workerId;
  final String workerName;

  AttendanceFormPage({required this.workerId, required this.workerName});

  @override
  _AttendanceFormPageState createState() => _AttendanceFormPageState();
}

class _AttendanceFormPageState extends State<AttendanceFormPage> {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  final _formKey = GlobalKey<FormState>();
  bool _isPresent = false;
  TextEditingController _dateController = TextEditingController();
  String _errorMessage = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
    // fcm.getToken().then((token) {
    // print("this is token:" + token!);
    // });
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

        if (existingDateAdded != null && existingDateAdded) {
          Fluttertoast.showToast(
            msg: 'Attendance for this date already existsssss',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          Noti.showBigTextNotification(
              title: "Add Attendance",
              body: "${widget.workerName} added Attendance to him",
              fln: flutterLocalNotificationsPlugin);
        }
      } else {
        Noti.showBigTextNotification(
            title: "Add Attendance",
            body: "Attendance for this date already exists",
            fln: flutterLocalNotificationsPlugin);
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
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            submitAttendance();
                            // Noti.showBigTextNotification(title: "Add Attendance", body: "${widget.workerName} add attendance for you", fln:flutterLocalNotificationsPlugin );
                          },
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

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    // var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(
      android: androidInitialize,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('mipmap/ic_launcher'),
      importance: Importance.max,
      priority: Priority.high,
      largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
    );

    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await fln.show(0, title, body, not);
  }
}
