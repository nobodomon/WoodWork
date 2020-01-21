import 'package:flutter/material.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';

class AHome extends StatefulWidget{
  AHome({this.auth,});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> AHomeState();

}

class AHomeState extends State<AHome>{
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: widget.auth.getCurrentUser(),
      builder: (BuildContext context,AsyncSnapshot<UserProfile> user){
        if(user.hasData){
          return new Scaffold(
            body: ListView(
              children: <Widget>[
                new ListTile(
                  title: new Text(user.data.fsUser.data['Name']),
                )
              ],
            ),
          );
        }else{
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}