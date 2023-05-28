import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:construction_company/special_pages/Map.dart';
import 'package:construction_company/special_pages/projectOverview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddWorker extends StatefulWidget {
  @override
  _AddWorkerState createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();
  final latitude = TextEditingController();
    final lagnitude = TextEditingController();

  // String _status = 'pending';
  File? _image;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      print(_image!.path);
      var request = http.MultipartRequest(
          "POST", Uri.parse('http://10.0.2.2:3000/Worker/AddWorker'));
      var length = await _image!.length();
      var stream = http.ByteStream(_image!.openRead());
      var multipartData = http.MultipartFile('media', stream, length,
          filename: basename(_image!.path));
      request.files.add(multipartData);
      request.fields['name'] = _nameController.text;
      request.fields['address'] = _addressController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['salary'] = _salaryController.text;
      request.fields['latitude'] = latitude.text;
      request.fields['longitude'] = lagnitude.text;
      var myRequest = await request.send();
      var response = await http.Response.fromStream(myRequest);
      // print(response.body);
      if (myRequest.statusCode == 201) {
        QuickAlert.show(
          confirmBtnText: 'Save',
          confirmBtnColor: Color(0xfff7b858),
          onConfirmBtnTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MyApp();
            }));
          },
          context: context,
          type: QuickAlertType.success,
          text: 'New Worker Created Successfully to Company!',
        );
      } else {
        // print('error${myRequest}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error Adding Worker")));
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff7b858),
        title: Text('Add Worker'),
        leading: Center(
            child: Icon(
          Icons.add_box,
        )),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'Worker Name', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a worker name';
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
                      controller: _addressController,
                      decoration: InputDecoration(
                          labelText: 'Address', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a address';
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
                      controller: _phoneController,
                      decoration: InputDecoration(
                          labelText: 'Phone', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a address';
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
                      controller: _salaryController,
                      decoration: InputDecoration(
                          labelText: 'Salary', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a salary';
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
                      controller: latitude,
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
                      controller: lagnitude,
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
                  onPressed: _pickImage,
                  child: Text(
                    'Choose Image',
                  ),
                ),
                SizedBox(height: 16.0),
                if (_image != null) ...[
                  Image.file(
                    _image!,
                    height: 200,
                  ),
                  SizedBox(height: 16.0),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xfff7b858),
                  ),
                  onPressed: () => submit(context),
                  child: Text('Add Worker'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
