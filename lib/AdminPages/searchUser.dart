import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new SearchUserState();
}

class SearchUserState extends State<SearchUser>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Center(child: new Text("search to be made"),),
    );
  }

}