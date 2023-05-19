import 'package:flutter/material.dart';

class AllTasksInCompany extends StatefulWidget {
  const AllTasksInCompany({super.key});

  @override
  State<AllTasksInCompany> createState() => _AllTasksInCompanyState();
}

class _AllTasksInCompanyState extends State<AllTasksInCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tasks In Company"),
      ),
      body: Center(child: Text("All Tasks")),
    );
  }
}
