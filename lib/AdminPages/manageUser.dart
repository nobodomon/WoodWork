import 'package:flutter/material.dart';

class ManageUser extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Center(
        child: new Text("Management"),
      ),
    );
  }
}