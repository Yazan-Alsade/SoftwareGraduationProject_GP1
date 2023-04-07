import 'package:flutter/material.dart';

class WorkerTrack extends StatefulWidget {
  @override
  _WorkerTrackState createState() => _WorkerTrackState();
}

class _WorkerTrackState extends State<WorkerTrack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Worker Track"),
      ),
      body: Center(
        child: Text("Worker Track",style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
