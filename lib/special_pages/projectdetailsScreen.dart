import 'dart:convert';
import 'dart:io';
import 'package:construction_company/special_pages/projectOverview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String ProjecctNumber;

  const ProjectDetailsScreen({Key? key, required this.ProjecctNumber})
      : super(key: key);

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ProjeNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _staffController = TextEditingController();
  final _companyController = TextEditingController();
  String _statusController = "pending";
  final _materialsController = TextEditingController();
  var _priceController = TextEditingController();
  // final _imageUrlController = TextEditingController();
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

  Future<void> addProject(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      // Check if a project with the same name already exists
      double price = double.parse(_priceController.text);
      double projNum = double.parse(_ProjeNumberController.text);
      print(_image!.path);
      var request = http.MultipartRequest(
          "POST", Uri.parse('http://10.0.2.2:3000/Details/AddDetails'));
      var length = await _image!.length();
      var stream = http.ByteStream(_image!.openRead());
      var multipartData = http.MultipartFile('media', stream, length,
          filename: basename(_image!.path));
      request.files.add(multipartData);
      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['status'] = _statusController;
      request.fields['company'] = _companyController.text;
      request.fields['staff'] = _staffController.text;
      request.fields['price'] = price.toStringAsFixed(2);
      request.fields['materials'] = _materialsController.text;
      request.fields['ProjecctNumber'] = projNum.toStringAsFixed(2);

      var myRequest = await request.send();
      var response = await http.Response.fromStream(myRequest);
      print(response.body);
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
          text: 'New Project Details Created Successfully!',
        );
      } else {
        // print('error${myRequest}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error creating project details")));
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
        title: Text(widget.ProjecctNumber),
        centerTitle: true,
        backgroundColor: Color(0xfff7b858),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    'project ${widget.ProjecctNumber}',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project description';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: DropdownButtonFormField<String>(
                        value: _statusController,
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
                            _statusController = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _companyController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Company',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _staffController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Staff',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project staff';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _materialsController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Materials',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project materials';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Price',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: TextFormField(
                        controller: _ProjeNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Project Number',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project number';
                          }
                          return null;
                        },
                      ),
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
                  SizedBox(height: 10),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xfff7b858),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addProject(context);
                    }
                  },
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
