import 'package:flutter/material.dart';
import 'package:woodwork/AdminPages/adminHome.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/ContractorPages/contractorHome.dart';
import 'package:woodwork/login.dart';
import 'Authentication/Authentication.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget{
  RootPage({this.auth});

  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> new RootPageState();
}

class RootPageState extends State<RootPage>{
  
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  UserProfile currUser;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currUser = user;
        }else{

        }
        authStatus =
            user.fbUser?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
      widget.auth.getCurrentUser().then((user) {
        setState(() {
          currUser = user;
        });
      });
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    }

  Scaffold buildWaitingScreen(){
    return new Scaffold(
      body: new Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      currUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new Login(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (currUser.fbUser.uid.length > 0 && currUser != null) {
          switch(currUser.fsUser.data["Usertype"]){
            case 1: return new ContractorHome(
                auth: widget.auth,
                logoutCallback: logoutCallback,
              );
              break;

            case 99: return new AdminHome(
              );
              break;

            default: break;
          }
          
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
  
}