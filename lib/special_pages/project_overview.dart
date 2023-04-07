import 'dart:convert';
import 'package:flutter/material.dart';
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
          project['imageUrl'] = 'http://10.0.2.2:3000/uploads/${project['media']}';
          return project;
        }).toList();
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                    // onChanged: (value) => _runFilter(value),
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
                    ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.network(projects[index]['imageUrl']),
                            title: Text(projects[index]['name'] ?? ''),
                            subtitle:
                                Text(projects[index]['description'] ?? ''),
                            trailing: Text(projects[index]['status'] ?? ''),
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: pendingProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                          leading: Image.network(pendingProjects[index]['imageUrl']),
                            title: Text(pendingProjects[index]['name'] ?? ''),
                            subtitle: Text(
                                pendingProjects[index]['description'] ?? ''),
                            trailing:
                                Text(pendingProjects[index]['status'] ?? ''),
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: overdueProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.network(overdueProjects[index]['imageUrl']),
                            title: Text(overdueProjects[index]['name'] ?? ''),
                            subtitle: Text(
                                overdueProjects[index]['description'] ?? ''),
                            trailing:
                                Text(overdueProjects[index]['status'] ?? ''),
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: completedProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.network(completedProjects[index]['imageUrl']),
                            title: Text(completedProjects[index]['name'] ?? ''),
                            subtitle: Text(
                                completedProjects[index]['description'] ?? ''),
                            trailing:
                                Text(completedProjects[index]['status'] ?? ''),
                          ),
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
