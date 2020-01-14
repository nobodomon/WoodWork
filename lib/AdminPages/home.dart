import 'package:flutter/material.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';

class aHome extends StatefulWidget{
  aHome({this.auth,});
  BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> aHomeState();

}

class aHomeState extends State<aHome>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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