import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      final url =
          'http://10.0.2.2:3000/Worker/getProjectTasks/${widget.projectId}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tasks = data['tasks'];
        });
        if (tasks.isEmpty) {
          showNoTasksDialog(context);
        }
      } else {
        throw Exception('Failed to fetch tasks');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void showNoTasksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Tasks'),
          content: Text('This project does not have any tasks.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double calculateCompletionPercentage() {
    if (tasks.isEmpty) {
      return 0.0;
    }

    int completedTasks = 0;
    for (var task in tasks) {
      if (task['status'] == 'completed') {
        completedTasks++;
      }
    }

    return (completedTasks / tasks.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
        backgroundColor: Color(0xfff7b858),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.assignment, size: 28),
                SizedBox(width: 8),
                Text(
                  'Tasks (${tasks.length})', // Displaying the task count
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Completion: ${calculateCompletionPercentage().toStringAsFixed(2)} %', // Displaying the completion percentage
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task ${index + 1}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xfff7b858),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        DataTable(
                          columnSpacing: 16,
                          headingRowHeight: 48,
                          dataRowHeight: 56,
                          horizontalMargin: 0,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Field',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Value',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  tasks[index]['description'],
                                ),
                              ),
                            ]),
                            DataRow(cells: [
                              DataCell(
                                Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text(tasks[index]['status'])),
                            ]),
                            DataRow(cells: [
                              DataCell(
                                Text(
                                  'Start Time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text(tasks[index]['startTime'])),
                            ]),
                            DataRow(cells: [
                              DataCell(
                                Text(
                                  'End Time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text(tasks[index]['endTime'])),
                            ]),
                            DataRow(cells: [
                              DataCell(
                                Text(
                                  'Reward',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(tasks[index]['reward'].toString()),
                              ),
                            ]),
                            DataRow(cells: [
                              DataCell(
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(tasks[index]['discount'].toString()),
                              ),
                            ]),
                          ],
                        ),
                      ],
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
}
