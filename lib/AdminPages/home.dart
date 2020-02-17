import 'package:flutter/material.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class AHome extends StatefulWidget{
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  AHome({this.auth, this.accentFontColor, this.accentColor, this.fontColor,});
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
                Container(
                  color: widget.accentColor,
                  child: new ListTile(
                    
                    title: new Text("Welcome " + user.data.fsUser.data['Name'],
                    style: TextStyle(color: widget.fontColor),),
                  ),
                ),
                dashBoardContainer(context),
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

  Widget dashBoardContainer(BuildContext context){
    return Container(
      width: double.maxFinite,
      height: 250,
      decoration: BoxDecoration(
        gradient: CommonWidgets.mainGradient
      ),
    );
  }

}