import 'package:carousel_slider/carousel_slider.dart';
import 'package:construction_company/special_pages/projectOverview.dart';
import 'package:construction_company/special_pages/workers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'const.dart';

class WorkerTasksPage extends StatefulWidget {
  final List<Task> tasks;
  final String workerName;
  final String workerId;

  const WorkerTasksPage(
      {required this.tasks, required this.workerName, required this.workerId});

  @override
  _WorkerTasksPageState createState() => _WorkerTasksPageState();
}

class _WorkerTasksPageState extends State<WorkerTasksPage> {
  bool showNoTasksDialog = false;

  Future<void> fetchAttendance(String workerId) async {
    try {
      final response = await http.get(
          Uri.parse('$apiBaseUrl:3000/Worker/ShowAttendance/$workerId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final presentDates = jsonData['presentDates'];
        final absentDates = jsonData['absentDates'];
        final totalWorkingDays = jsonData['totalWorkingDays'];
        final totalPresentDays = jsonData['totalPresentDays'];
        final totalAbsentDays = jsonData['totalAbsentDays'];

        // Display the attendance data or handle it as needed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance for ${widget.workerName}',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    SizedBox(height: 16.0),
                    Table(
                      border: TableBorder.all(color: Colors.grey),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        _buildTableRow(
                            'Total Working Days', totalWorkingDays.toString()),
                        _buildTableRow(
                            'Total Present Days', totalPresentDays.toString()),
                        _buildTableRow(
                            'Total Absent Days', totalAbsentDays.toString()),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Present Dates:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      height: 120.0, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: presentDates.length,
                        itemBuilder: (context, index) {
                          final date = DateTime.parse(presentDates[index]);
                          final formattedDate =
                              DateFormat.yMMMMd().format(date);

                          return Text(
                            date.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      'Absent Dates:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                          fontSize: 16),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      height: 120.0, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: absentDates.length,
                        itemBuilder: (context, index) {
                          final date = DateTime.parse(absentDates[index]);
                          return Text(
                            date.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                          Color(0xfff7b858),
                        )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Handle error
        print(
            'Failed to fetch attendance. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch attendance. Error: $error');
    }
  }

  Future<void> fetchSalaryHistoryForWorker(String workerId) async {
    try {
      final response = await http
          .get(Uri.parse('$apiBaseUrl:3000/Worker/ShowSalary/$workerId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final reportData = jsonData['report'];

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 8.0,
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reportData['workerName'],
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Salary Component')),
                        DataColumn(label: Text('Amount')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Total Present Days:')),
                          DataCell(Text(
                            reportData['totalPresentDays'].toString(),
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Salary per Day:')),
                          DataCell(Text(
                            reportData['salaryPerDay'],
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Total Salary:')),
                          DataCell(Text(
                            reportData['totalSalary'].toString(),
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          )),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Handle error
        print(
            'Failed to fetch salary history. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch salary history. Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.tasks.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Tasks Available"),
              content: Text('${widget.workerName} has no tasks.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"),
                )
              ],
            );
          },
        );
      }
    });
    final List<String> imageUrls = [
      "images/istockphoto-1404515405-612x612.jpg",
      "images/istockphoto-1404515487-612x612.jpg",
      "images/istockphoto-1404515422-612x612.jpg",
      "images/istockphoto-1015315514-612x612.jpg",
      "images/istockphoto-1297546608-612x612.jpg",
      "images/istockphoto-1297780279-612x612.jpg",
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfff7b858),
        onPressed: () {
          fetchAttendance(widget.workerId);
        },
        child: Icon(
          Icons.date_range,
        ),
      ),
      appBar: AppBar(
        title: Text('Tasks For ${widget.workerName}'),
        centerTitle: true,
        backgroundColor: Color(0xfff7b858),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
                items: imageUrls.map((url) {
                  return Container(
                    child: Image.asset(
                      width: MediaQuery.of(context).size.width,
                      url,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(microseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {})),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                return Container(
                  margin: EdgeInsets.all(5),
                  child: Card(
                    elevation: 5.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.description,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xfff7b858),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Table(
                            border: TableBorder.all(color: Colors.grey),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              _buildTableRow('Status', task.status),
                              _buildTableRow(
                                  'Start Time', task.startTime.toString()),
                              _buildTableRow(
                                  'End Time', task.endTime.toString()),
                              _buildTableRow('Reward', task.reward.toString()),
                              _buildTableRow(
                                  'Discount', task.discount.toString()),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(30)),
                                child: TextButton(
                                  onPressed: () {
                                    fetchSalaryHistoryForWorker(
                                        widget.workerId);
                                    // Handle button press
                                  },
                                  child: Text(
                                    'Show Salary',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(30)),
                                child: TextButton(
                                  onPressed: () {
                                    _updateTaskStatus(task.taskId);
                                    // Handle button press
                                  },
                                  child: Text(
                                    'Complete',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateTaskStatus(String taskId) async {
    final url = Uri.parse('$apiBaseUrl:3000/Worker/$taskId');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'status': 'completed'});

    try {
      // Fetch the task with the given taskId
      final task = widget.tasks.firstWhere((task) => task.taskId == taskId);

      // Check if the task status is already "completed"
      if (task.status == 'completed') {
        QuickAlert.show(
          confirmBtnText: 'Ok',
          confirmBtnColor: Color(0xfff7b858),
          onConfirmBtnTap: () {},
          context: context,
          type: QuickAlertType.info,
          text: 'This task has already been completed.',
        );
        print('Task is already completed');

        return; // Skip updating the task status
      }

      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        QuickAlert.show(
          confirmBtnText: 'Save',
          confirmBtnColor: Color(0xfff7b858),
          onConfirmBtnTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WorkersPage();
            }));
          },
          context: context,
          type: QuickAlertType.success,
          text: 'This Task has updated Successfully',
        );
        // Task status updated successfully
        print('Task status updated');
        // Update the task status in the local tasks list
        setState(() {
          task.status = 'completed';
        });
      } else {
        // Failed to update task status
        print(
            'Failed to update task status. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Failed to update task status. Error: $error');
    }
  }

  TableRow _buildTableRow(String property, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              property,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Task {
  final String taskId;
  final String description;
  String status;
  final DateTime startTime;
  final DateTime endTime;
  final int reward;
  final int discount;

  Task({
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.reward,
    required this.discount,
    required this.taskId,
  });
}
