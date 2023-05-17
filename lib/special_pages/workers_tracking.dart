import 'package:construction_company/special_pages/addWorker.dart';
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
              // Handle worker tap
            },
          );
        }),
      ),
    );
  }
}

class Worker {
  final String name;
  final String address;
  final String phone;
  final String salary;
  final String media;

  Worker({
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
