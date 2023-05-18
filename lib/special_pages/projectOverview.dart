import 'dart:convert';
import 'package:construction_company/special_pages/notification.dart';
import 'package:construction_company/special_pages/addProject.dart';
import 'package:construction_company/special_pages/projectdetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<dynamic> projects = [];
  List<dynamic> pendingProjects = [];
  List<dynamic> overdueProjects = [];
  List<dynamic> completedProjects = [];
  final pendingIcon = Icon(Icons.pending, color: Colors.orange);
  final overdueIcon = Icon(Icons.warning, color: Colors.red);
  final completedIcon = Icon(Icons.check_circle, color: Colors.green);

  final searchController = TextEditingController();
  List<dynamic> displayedProjects = [];

  Future<void> getProjects() async {
    var response =
        await http.get(Uri.parse('http://10.0.2.2:3000/projects/projectsALL'));
    if (response.statusCode == 200) {
      setState(() {
        projects = jsonDecode(response.body);
        pendingProjects = projects
            .where((project) => project['status'] == 'pending')
            .toList();
        overdueProjects = projects
            .where((project) => project['status'] == 'overdue')
            .toList();
        completedProjects = projects
            .where((project) => project['status'] == 'completed')
            .toList();
        projects = projects.map((project) {
          project['imageUrl'] =
              'http://10.0.2.2:3000/uploads/${project['media']}';
          return project;
        }).toList();
        displayedProjects = projects;
      });
    } else {
      print('Failed to load projects');
    }
  }

  @override
  void initState() {
    super.initState();
    getProjects();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateDisplayedProjects(String searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() {
        displayedProjects = projects;
      });
    } else {
      setState(() {
        displayedProjects = projects.where((project) {
          return project['name']
              .toLowerCase()
              .contains(searchTerm.toLowerCase());
        }).toList();
      });
    }
  }

  //////// class project to add project

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddProjectScreen();
            }));
          },
          child: Icon(Icons.add),
        ),
        backgroundColor: Color.fromARGB(255, 240, 234, 234),
        appBar: AppBar(
          title: Text("Projects"),
          backgroundColor: Color(0xfff7b858),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Card(
                  elevation: 6,
                  child: TextField(
                    controller: searchController,
                    onChanged: updateDisplayedProjects,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15),
                      hintText: "Search",
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Color(0xfff7b858),
                      ),
                      // prefix: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Color(0xfff7b858),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Column(
                      children: [
                        Tab(
                          text: 'All',
                        ),
                        Text("(${projects.length})"),
                      ],
                    ),
                    Column(
                      children: [
                        Tab(
                          text: 'Pending',
                        ),
                        Text("(${pendingProjects.length})"),
                      ],
                    ),
                    Column(
                      children: [
                        Tab(
                          text: 'Overdue',
                        ),
                        Text("(${overdueProjects.length})"),
                      ],
                    ),
                    Column(
                      children: [
                        Tab(
                          text: 'Completed',
                        ),
                        Text("(${completedProjects.length})"),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // All Projects
                    ListView.builder(
                      itemCount: displayedProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Card(
                              elevation: 6,
                              child: GestureDetector(
                                onTap: () {
                                  final String projectId =
                                      displayedProjects[index]['_id'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailsScreen(
                                          projectId: projectId,
                                        ),
                                      ));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            projects[index]['imageUrl'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              displayedProjects[index]['name'],
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              projects[index]['description'] ??
                                                  '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // Container(
                                            //   height: 30,
                                            //   color: Color(0xfff7b858),
                                            //   child: TextButton(
                                            //     onPressed: () {},
                                            //     child: Text(
                                            //       'Show More',
                                            //       style: TextStyle(
                                            //           color: Colors.white),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Column(
                                          children: [
                                            (projects[index]['status'] ==
                                                    'pending')
                                                ? Tooltip(
                                                    message: (projects[index]
                                                                ['status'] ==
                                                            'pending')
                                                        ? 'pending'
                                                        : (projects[index]['status'] ==
                                                                'overdue')
                                                            ? 'overdue'
                                                            : 'completed',
                                                    child: pendingIcon)
                                                : (projects[index]['status'] ==
                                                        'overdue')
                                                    ? Tooltip(
                                                        message: (projects[index]
                                                                    [
                                                                    'status'] ==
                                                                'pending')
                                                            ? 'pending'
                                                            : (projects[index]['status'] ==
                                                                    'overdue')
                                                                ? 'overdue'
                                                                : 'completed',
                                                        child: overdueIcon)
                                                    : Tooltip(
                                                        message: (projects[index]
                                                                    [
                                                                    'status'] ==
                                                                'pending')
                                                            ? 'pending'
                                                            : (projects[index]
                                                                        ['status'] ==
                                                                    'overdue')
                                                                ? 'overdue'
                                                                : 'completed',
                                                        child: completedIcon),
                                            Text(
                                              '${projects[index]['status']}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: (projects[index]
                                                            ['status'] ==
                                                        'pending')
                                                    ? Colors.orange
                                                    : (projects[index]
                                                                ['status'] ==
                                                            'overdue')
                                                        ? Colors.red
                                                        : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // Pending Projects
                    ListView.builder(
                      itemCount: pendingProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: (){
                                   final String projectId =
                                      pendingProjects[index]['_id'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailsScreen(
                                          projectId: projectId,
                                        ),
                                      ));
                                },
                                child: Card(
                                  elevation: 6,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              pendingProjects[index]['imageUrl'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pendingProjects[index]['name'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                pendingProjects[index]
                                                        ['description'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(20),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            children: [
                                              (pendingProjects[index]['status'] ==
                                                      'pending')
                                                  ? Tooltip(
                                                      message: (pendingProjects[index]
                                                                  ['status'] ==
                                                              'pending')
                                                          ? 'pending'
                                                          : (pendingProjects[index]['status'] ==
                                                                  'overdue')
                                                              ? 'overdue'
                                                              : 'completed',
                                                      child: pendingIcon)
                                                  : (pendingProjects[index]
                                                              ['status'] ==
                                                          'overdue')
                                                      ? Tooltip(
                                                          message: (pendingProjects[index][
                                                                      'status'] ==
                                                                  'pending')
                                                              ? 'pending'
                                                              : (pendingProjects[index]['status'] ==
                                                                      'overdue')
                                                                  ? 'overdue'
                                                                  : 'completed',
                                                          child: overdueIcon)
                                                      : Tooltip(
                                                          message: (pendingProjects[index][
                                                                      'status'] ==
                                                                  'pending')
                                                              ? 'pending'
                                                              : (pendingProjects[index]
                                                                          ['status'] ==
                                                                      'overdue')
                                                                  ? 'overdue'
                                                                  : 'completed',
                                                          child: completedIcon),
                                              Text(
                                                '${pendingProjects[index]['status']}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: (pendingProjects[index]
                                                              ['status'] ==
                                                          'pending')
                                                      ? Colors.orange
                                                      : (pendingProjects[index]
                                                                  ['status'] ==
                                                              'overdue')
                                                          ? Colors.red
                                                          : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // Overdue Projects
                    ListView.builder(
                      itemCount: overdueProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                   final String projectId =
                                      overdueProjects[index]['_id'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailsScreen(
                                          projectId: projectId,
                                        ),
                                      ));
                                },
                                child: Card(
                                  elevation: 6,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              overdueProjects[index]['imageUrl'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overdueProjects[index]['name'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                overdueProjects[index]
                                                        ['description'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(20),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            children: [
                                              (overdueProjects[index]['status'] ==
                                                      'pending')
                                                  ? Tooltip(
                                                      message: (overdueProjects[index]
                                                                  ['status'] ==
                                                              'pending')
                                                          ? 'pending'
                                                          : (overdueProjects[index]['status'] ==
                                                                  'overdue')
                                                              ? 'overdue'
                                                              : 'completed',
                                                      child: pendingIcon)
                                                  : (overdueProjects[index]
                                                              ['status'] ==
                                                          'overdue')
                                                      ? Tooltip(
                                                          message: (overdueProjects[index][
                                                                      'status'] ==
                                                                  'pending')
                                                              ? 'pending'
                                                              : (overdueProjects[index]['status'] ==
                                                                      'overdue')
                                                                  ? 'overdue'
                                                                  : 'completed',
                                                          child: overdueIcon)
                                                      : Tooltip(
                                                          message: (overdueProjects[index][
                                                                      'status'] ==
                                                                  'pending')
                                                              ? 'pending'
                                                              : (overdueProjects[index]
                                                                          ['status'] ==
                                                                      'overdue')
                                                                  ? 'overdue'
                                                                  : 'completed',
                                                          child: completedIcon),
                                              Text(
                                                '${overdueProjects[index]['status']}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: (overdueProjects[index]
                                                              ['status'] ==
                                                          'pending')
                                                      ? Colors.orange
                                                      : (overdueProjects[index]
                                                                  ['status'] ==
                                                              'overdue')
                                                          ? Colors.red
                                                          : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // Completed Projects
                    ListView.builder(
                      itemCount: completedProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: (){
                                   final String projectId =
                                      completedProjects[index]['_id'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailsScreen(
                                          projectId: projectId,
                                        ),
                                      ));
                                },
                                child: Card(
                                  elevation: 6,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              completedProjects[index]
                                                  ['imageUrl'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                completedProjects[index]['name'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                completedProjects[index]
                                                        ['description'] ??
                                                    '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(20),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            children: [
                                              (completedProjects[index]['status'] ==
                                                      'pending')
                                                  ? Tooltip(
                                                      message: (completedProjects[index]
                                                                  ['status'] ==
                                                              'pending')
                                                          ? 'pending'
                                                          : (completedProjects[index]['status'] ==
                                                                  'overdue')
                                                              ? 'overdue'
                                                              : 'completed',
                                                      child: pendingIcon)
                                                  : (completedProjects[index]
                                                              ['status'] ==
                                                          'overdue')
                                                      ? Tooltip(
                                                          message: (completedProjects[index][
                                                                      'status'] ==
                                                                  'pending')
                                                              ? 'pending'
                                                              : (completedProjects[index]['status'] ==
                                                                      'overdue')
                                                                  ? 'overdue'
                                                                  : 'completed',
                                                          child: overdueIcon)
                                                      : Tooltip(
                                                          message: (completedProjects[index][
                                                                      'status'] ==
                                                                  'pending')
                                                              ? 'pending'
                                                              : (completedProjects[index]
                                                                          ['status'] ==
                                                                      'overdue')
                                                                  ? 'overdue'
                                                                  : 'completed',
                                                          child: completedIcon),
                                              Text(
                                                '${completedProjects[index]['status']}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: (completedProjects[index]
                                                              ['status'] ==
                                                          'pending')
                                                      ? Colors.orange
                                                      : (completedProjects[index]
                                                                  ['status'] ==
                                                              'overdue')
                                                          ? Colors.red
                                                          : Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
