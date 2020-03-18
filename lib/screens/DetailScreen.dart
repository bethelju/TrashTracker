import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget{
  final DocumentSnapshot data;
  DetailScreen({this.data});

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wasteagram"),
        centerTitle: true
      ),
      body: Center(
          child: Column(
            children: [
              Text("${data['Date']}"),
              Container(
                child: Image.network("${data['url']}"),
                height: 350,
                width: 500
              ),
              Text("${data['number_items']}"),
              Text("(${data['latitude']}, ${data['longitude']})")
            ]
        )
      )
    );
  }
}