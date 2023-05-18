// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class WorkerTasksPage extends StatelessWidget {
//   final List<Task> tasks;
//   final String workerName;

//   const WorkerTasksPage({required this.tasks, required this.workerName});
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//   if (tasks.isEmpty) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("No Tasks Available"),
//           content: Text('$workerName has no tasks.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text("Ok"),
//             )
//           ],
//         );
//       },
//     );
//   }
// });

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(Icons.add),
//       ),
//       appBar: AppBar(
//         title: Text('Tasks For ${workerName}'),
//         centerTitle: true,
//         backgroundColor: Color(0xfff7b858),
//       ),
//       body: ListView.builder(
//         itemCount: tasks.length,
//         itemBuilder: (context, index) {
//           final task = tasks[index];
//           return Container(
//             margin: EdgeInsets.all(5),
//             child: Card(
//               elevation: 5.0,
//               margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       task.description,
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     Table(
//                       border: TableBorder.all(color: Colors.grey),
//                       defaultVerticalAlignment:
//                           TableCellVerticalAlignment.middle,
//                       children: [
//                         _buildTableRow('Status', task.status),
//                         _buildTableRow('Start Time', task.startTime.toString()),
//                         _buildTableRow('End Time', task.endTime.toString()),
//                         _buildTableRow('Reward', task.reward.toString()),
//                         _buildTableRow('Discount', task.discount.toString()),
//                       ],
//                     ),
//                     SizedBox(height: 16.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             // Handle button press
//                           },
//                           child: Text(
//                             'Complete',
//                             style: TextStyle(
//                               fontSize: 14.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   TableRow _buildTableRow(String property, String value) {
//     return TableRow(
//       children: [
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               property,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         TableCell(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(value),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Task {
//   final String description;
//   final String status;
//   final DateTime startTime;
//   final DateTime endTime;
//   final int reward;
//   final int discount;

//   Task({
//     required this.description,
//     required
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkerTasksPage extends StatefulWidget {
  final List<Task> tasks;
  final String workerName;

  const WorkerTasksPage({required this.tasks, required this.workerName});

  @override
  _WorkerTasksPageState createState() => _WorkerTasksPageState();
}

class _WorkerTasksPageState extends State<WorkerTasksPage> {
  bool showNoTasksDialog = false;

////////////////////

///////////////////

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks For ${widget.workerName}'),
        centerTitle: true,
        backgroundColor: Color(0xfff7b858),
      ),
      body: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          return Container(
            margin: EdgeInsets.all(5),
            child: Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Table(
                      border: TableBorder.all(color: Colors.grey),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        _buildTableRow('Status', task.status),
                        _buildTableRow('Start Time', task.startTime.toString()),
                        _buildTableRow('End Time', task.endTime.toString()),
                        _buildTableRow('Reward', task.reward.toString()),
                        _buildTableRow('Discount', task.discount.toString()),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Handle button press
                          },
                          child: Text(
                            'Complete',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
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
    );
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
  final String description;
  final String status;
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
  });
}
