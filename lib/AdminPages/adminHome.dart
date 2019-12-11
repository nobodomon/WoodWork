import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AdminHomeState();

}

class _AdminHomeState extends State<AdminHome>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text("AdminHome"),
      ),
      
    );
  }
  
}