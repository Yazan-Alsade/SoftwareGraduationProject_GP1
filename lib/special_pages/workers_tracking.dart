import 'package:construction_company/special_pages/addWorker.dart';
import 'package:construction_company/special_pages/tasks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkersPage extends StatefulWidget {
  @override
  _WorkersPageState createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  List<Worker> workers = []; // Define an empty list of workers

  @override
  void initState() {
    super.initState();
    fetchWorkers(); // Fetch workers data when the widget is initialized
  }



  Future<void> fetchTasksForWorker(String workerId,String workername) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/Worker/tasks/$workerId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tasksData = jsonData['tasks'];

        List<Task> tasks = tasksData
            .map<Task>((tasksData) {
              return Task(
                description: tasksData['description'],
                status: tasksData['status'],
                startTime: DateTime.parse(tasksData['startTime']),
                endTime: DateTime.parse(tasksData['endTime']),
                reward: tasksData['reward'],
                discount: tasksData['discount'],
              );
            })
            .toList();

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WorkerTasksPage(tasks: tasks,workerName:workername,);
        }));

        // Process the retrieved tasks data as needed
        // ...
      } else {
        // Handle error
        print('Failed to fetch tasks. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch tasks. Error: $error');
    }
  }

  Future<void> fetchWorkers() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/Worker/GetAllWorker'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final workersData = jsonData['workers'];

        setState(() {
          workers = workersData
              .map<Worker>((workerData) => Worker(
                    name: workerData['name'],
                    address: workerData['address'],
                    phone: workerData['phone'],
                    salary: workerData['salary'],
                    media: workerData['imageUrl'],
                    id: workerData['_id'],
                  ))
              .toList();
        });
      } else {
        // Handle error
        print('Failed to fetch workers. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch workers. Error: $error');
    }
  }

  Future<void> fetchAttendanceForWorker(String workerId) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/Worker/ShowAttendance/$workerId'),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<DateTime> presentDates = [];
        List<DateTime> absentDates = [];

        if (jsonData.containsKey('presentDates')) {
          final presentDatesData = jsonData['presentDates'];
          presentDates = presentDatesData.map<DateTime>((dateString) {
            return DateTime.parse(dateString);
          }).toList();
        }

        if (jsonData.containsKey('absentDates')) {
          final absentDatesData = jsonData['absentDates'];
          absentDates = absentDatesData.map<DateTime>((dateString) {
            return DateTime.parse(dateString);
          }).toList();
        }

        int totalWorkingDays = jsonData['totalWorkingDays'];
        int totalPresentDays = presentDates.length;
        int totalAbsentDays = absentDates.length;

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Attendance Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Present Dates: ${presentDates.join(", ")}'),
                  Text('Absent Dates: ${absentDates.join(", ")}'),
                  Text('Total Working Days: $totalWorkingDays'),
                  Text('Total Present Days: $totalPresentDays'),
                  Text('Total Absent Days: $totalAbsentDays'),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle error
        print('Failed to fetch attendance. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Failed to fetch attendance. Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfff7b858),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddWorker();
          }));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Workers'),
        centerTitle: true,
        backgroundColor: Color(0xfff7b858),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: List.generate(workers.length, (index) {
          final worker = workers[index];
          return WorkerCard(
            worker: worker,
            onTap: () {
              fetchTasksForWorker(worker.id,worker.name);
              // Handle worker tap
            },
          );
        }),
      ),
    );
  }
}

class Worker {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String salary;
  final String media;

  Worker({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.salary,
    required this.media,
  });
}

class WorkerCard extends StatelessWidget {
  final Worker worker;
  final VoidCallback onTap;

  const WorkerCard({
    required this.worker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xfff7b858),
              backgroundImage: NetworkImage(worker.media),
              radius: 40.0,
            ),
            SizedBox(height: 8.0),
            Text(
              worker.name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              worker.address,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 4.0),
            Text(
              worker.phone,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 4.0),
            Text(
              'Salary: ${worker.salary}',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
