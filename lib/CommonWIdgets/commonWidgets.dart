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
}