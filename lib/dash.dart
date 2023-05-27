import 'package:construction_company/special_pages/account.dart';
import 'package:construction_company/special_pages/Map.dart';
import 'package:construction_company/special_pages/equipmentDetails.dart';
import 'package:construction_company/special_pages/notification.dart';
import 'package:construction_company/special_pages/equipment.dart';
import 'package:construction_company/special_pages/logout.dart';
import 'package:construction_company/special_pages/materialcomp.dart';
import 'package:construction_company/special_pages/projectOverview.dart';
import 'package:construction_company/special_pages/salary.dart';
import 'package:construction_company/special_pages/tasks.dart';
import 'package:construction_company/special_pages/addWorker.dart';
import 'package:construction_company/special_pages/workers.dart';
import 'package:construction_company/widget/equipment/equipmentScreen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

var services = [
  "Project overview",
  "Equipment",
  "Workers",
  "Worker Tracking",
  "Notifications",
  "Profile",
  "Logout",
];
var images = [
  "images/project.png",
  "images/crane-truck.png",
  "images/tracking.png",
  "images/time.png",
  "images/notification.png",
  "images/profile.png",
  "images/log-out.png",
];

class _DashboardState extends State<Dashboard> {
  List<Widget> _pages = [
    ProjectScreen(),
    EquipmentScreen(),
    WorkersPage(),
    MyApp(),
    notifications(),
    Account(),
    Logout(),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: services.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.0),
        itemBuilder: (BuildContext, int index) {
          return Container(
            margin: EdgeInsets.all(10.0),
            child: Card(
              elevation: 10,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => _pages[index]));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      images[index],
                      height: 80,
                      width: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        services[index],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
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
}
