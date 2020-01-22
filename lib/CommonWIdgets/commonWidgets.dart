import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommonWidgets{
  
  static Scaffold pageLoadingScreen(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.black54,
      body: new Center(
        child: new CircularProgressIndicator(),
      )
    );
  }

  static String mapUserRoleToLongName(int userRole){
    String userTypeLong = "";
    switch (userRole) {
      case 1:
        userTypeLong = "Contractor";
        break;
      case 2:
        userTypeLong = "Production";
        break;
      case 3:
        userTypeLong = "Delivery";
        break;
      case 99:
        userTypeLong = "Admin";
        break;
      case 999:
        userTypeLong = "S.Admin";
        break;
      case -1:
        userTypeLong = "Invalid type!";
        break;
    }
    return userTypeLong;
  }

  static String timeStampToString(Timestamp input){
    DateTime d = input.toDate();
    String formattedDateTime = d.day.toString() + "/" + d.month.toString()+ "/" + d.year.toString() + "@" + d.hour.toString() + ":" + d.minute.toString();
    return formattedDateTime;
  }

  static Widget logoutDialog(BuildContext context, VoidCallback logoutCallback){
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        margin: new EdgeInsets.all(75),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              title: new Text("Log-out"),
              subtitle: new Text("Are you sure you want to log out?")
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new FlatButton(
                  child: new Text("Confirm"),
                  onPressed: (){
                    logoutCallback();
                    Navigator.of(context).pop();
                  }
                ),
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: ()=>{Navigator.of(context).pop()}
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}