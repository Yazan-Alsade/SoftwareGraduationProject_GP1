import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'addWorker.dart';

class Worker {
  final String id;
  final String name;
  final String address;
  final String phone;
  double latitude;
  double longitude;
  final String salary;
  final String media;

  Worker({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.salary,
    required this.media,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      salary: json['salary'],
      phone: json['phone'],
      latitude: json['latitude'] != null ? json['latitude'] : 0.0,
      longitude: json['longitude'] != null ? json['longitude'] : 0.0,
      media: json['imageUrl'],
    );
  }
}

class Task {
  final String id;
  final String description;
  final status;
  final startTime;
  final endTime;
  final reward;
  final discount;
  double latitude;
  double longitude;

  Task({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.discount,
    required this.endTime,
    required this.startTime,
    required this.reward,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      description: json['description'],
      status: json['status'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      discount: json['discount'],
      reward: json['reward'],
      latitude: json['latitude'] != null ? json['latitude'] : 0.0,
      longitude: json['longitude'] != null ? json['longitude'] : 0.0,
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Worker> workers = [];
  List<Task> tasks = [];
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  @override
  void initState() {
    super.initState();
    fetchAndSetWorkers();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      fetchAndSetWorkers();
    });
  }

  Future<List<Worker>> fetchWorkers() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/Worker/GetAllWorker'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final workers = List<Worker>.from(
          data['workers'].map((workerData) => Worker.fromJson(workerData)));
      return workers;
    } else {
      throw Exception('Failed to fetch workers');
    }
  }

  Future<List<Task>> fetchTasks() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/Worker/GetAllTask'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tasks = List<Task>.from(data.map((tasks) => Task.fromJson(tasks)));
      return tasks;
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  // Create a variable to track the selected worker marker
  // MarkerId? selectedWorkerMarkerId;
  Worker? selectedWorker;
  Task? selectedTask;
  MarkerId? selectedWorkerMarkerId;
  MarkerId? selectedTaskMarkerId;
  // Create a variable to store the selected worker
  // Worker? selectedWorker;

  // Handle worker marker tap event
  void onWorkerMarkerTapped(MarkerId markerId) {
    setState(() {
      // Find the selected worker using the markerId
      selectedWorker =
          workers.firstWhere((worker) => worker.id == markerId.value);

      // Store the selected markerId
      selectedWorkerMarkerId = markerId;
    });
  }

  void onTaskMarkerTapped(MarkerId markerId) {
    setState(() {
      // Find the selected task using the markerId
      selectedTask = tasks.firstWhere((task) => task.id == markerId.value);

      // Clear the selected worker
      selectedWorker = null;

      // Store the selected markerId
      selectedTaskMarkerId = markerId;
    });
  }

  void fetchAndSetWorkers() async {
    try {
      final fetchedWorkers = await fetchWorkers();
      final fetchedTasks = await fetchTasks();
      setState(() {
        workers = fetchedWorkers;
        tasks = fetchedTasks;
      });
    } catch (error) {
      // Handle error
    }
  }

  // ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 8,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                markers: <Marker>{
                  ...workers.map((worker) {
                    return Marker(
                        markerId: MarkerId(worker.id),
                        position: LatLng(worker.latitude, worker.longitude),
                        // infoWindow: InfoWindow(
                        //   title: worker.name,
                        //   snippet: worker.address,
                        // ),
                        onTap: () => onWorkerMarkerTapped(MarkerId(worker.id)),
                        icon: selectedWorkerMarkerId?.value == worker.id
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueYellow)
                            : BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed));
                  }),
                  ...tasks.map((task) {
                    return Marker(
                      markerId: MarkerId(task.id),
                      position: LatLng(task.latitude, task.longitude),
                      // infoWindow: InfoWindow(
                      //   title: task.description,
                      //   snippet: task.status,
                      // ),

                      onTap: () => onTaskMarkerTapped(MarkerId(
                          task.id)), // Call the handler when marker is tapped
                      icon: selectedTaskMarkerId?.value ==
                              task.id // Check if the marker is selected
                          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
                              .hueYellow) // Use a different marker color for selected task
                          : BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                    );
                  }),
                },
              ),
            ),
            if (selectedWorker != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedWorker!.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedWorker = null;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Image.network(
                        selectedWorker!.media,
                        width: 100,
                        height: 100,
                      ), // Replace with the image URL

                      Text(
                        'Address: ${selectedWorker!.address}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Phone: ${selectedWorker!.phone}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Salary: ${selectedWorker!.salary}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      // Add more worker information as needed
                      // ...
                    ],
                  ),
                ),
              ),
            // Show the task card when a task is selected
            if (selectedTask != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTask!.description,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                selectedTask = null;
                                selectedTaskMarkerId = null;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text('Status'),
                        subtitle: Text(selectedTask!.status),
                      ),
                      ListTile(
                        leading: Icon(Icons.timer),
                        title: Text('Start Time'),
                        subtitle: Text(selectedTask!.startTime),
                      ),
                      ListTile(
                        leading: Icon(Icons.timer_off),
                        title: Text('End Time'),
                        subtitle: Text(selectedTask!.endTime),
                      ),
                      // Add more information or widgets as needed
                    ],
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddWorker();
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xfff7b858),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Add Worker",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddWorker();
                        }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xfff7b858),
                        ),
                        child: Text(
                          "Add Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
