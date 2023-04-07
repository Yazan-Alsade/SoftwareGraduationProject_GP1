import 'package:flutter/material.dart';

class Project {
  String name;
  String description;
  
  Project({required this.name, required this.description});
}

class counter extends StatefulWidget {
  @override
  _counterState createState() => _counterState();
}

class _counterState extends State<counter> {
  int counter = 0;
  List<Project> projects = [];
  
  void addProject() {
    setState(() {
      counter++;
      projects.add(Project(name: "Project ${counter.toString()}", description: "Description ${counter.toString()}"));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Column(
        children: [
          Text('Number of projects: $counter'),
          ElevatedButton(
            onPressed: () => addProject(),
            child: Text('Add Project'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(projects[index].name),
                  subtitle: Text(projects[index].description),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
