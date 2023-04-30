import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:construction_company/special_pages/projectOverview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddProjectScreen extends StatefulWidget {
  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'pending';
  File? _image;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
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
      // Check if a project with the same name already exists
      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/projects/projectsALL'),
      );
      final projects = jsonDecode(res.body) as List<dynamic>;
      final projectExists = projects.any(
        (project) => project['name'] == _nameController.text,
      );
      if (projectExists) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'A project with the same name already exists.',
        );
        return;
      }
      print(_image!.path);
      var request = http.MultipartRequest(
          "POST", Uri.parse('http://10.0.2.2:3000/projects/AddProject'));
      var length = await _image!.length();
      var stream = http.ByteStream(_image!.openRead());
      var multipartData = http.MultipartFile('media', stream, length,
          filename: basename(_image!.path));
      request.files.add(multipartData);
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['status'] = _status;
      var myRequest = await request.send();
      var response = await http.Response.fromStream(myRequest);
      // print(response.body);
      if (myRequest.statusCode != 200) {
        QuickAlert.show(
          confirmBtnText: 'Save',
          confirmBtnColor: Color(0xfff7b858),
          onConfirmBtnTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProjectScreen();
            }));
          },
          context: context,
          type: QuickAlertType.success,
          text: 'New Project Created Successfully!',
        );
      } else {
        // print('error${myRequest}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error creating project")));
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
        title: Text('Add Project'),
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
                          'Please Add New Project:',
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
                          labelText: 'Project Name', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a project name';
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
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Description', border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
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
                    child: DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(
                          labelText: 'Status', border: InputBorder.none),
                      items: [
                        DropdownMenuItem(
                            child: Text('Pending'), value: 'pending'),
                        DropdownMenuItem(
                            child: Text('Overdue'), value: 'overdue'),
                        DropdownMenuItem(
                            child: Text('Completed'), value: 'completed'),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
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
                  child: Text('Add Project'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
