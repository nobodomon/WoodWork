import 'package:flutter/material.dart';
/*
class Scan extends StatefulWidget{
  final String pageInfo;
  Scan(this.pageInfo);

  @override
  State<StatefulWidget> createState() => new ScanState(pageInfo);
  
}

class ScanState extends State<Scan>{
  final String pageInfo;
  ScanState(this.pageInfo);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Center(
        child: new Text(pageInfo),
      ),
    );
  }
}
*/

class Scan extends StatelessWidget{
  final String pageInfo;
  Scan(this.pageInfo);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Center(
        child: new Text(pageInfo),
      )
    );
  }
  
}