import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/AdminPages/adminHome.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ContractorPages/contractorHome.dart';
import 'package:woodwork/DeliveryPages/DeliveryHome.dart';
import 'package:woodwork/ProductionPages/productionHome.dart';
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
  
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  UserProfile currUser;

  Color accentFontColor;
  Color accentColor;
  Color fontColor;
  Gradient mainGradient;
  Gradient subGradient;
  @override
  void initState() {
    super.initState();
    fontColor = CommonWidgets.fontColor;
    accentColor = CommonWidgets.accentColor;
    accentFontColor = CommonWidgets.accentFontColor;
    mainGradient = CommonWidgets.mainGradient;
    subGradient= CommonWidgets.subGradient;
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          currUser = user;
        }else{

        }
        authStatus =
            user == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
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
      widget.auth.signOut();
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
          fontColor: fontColor,
          accentFontColor: accentFontColor,
          accentColor: accentColor
        );
        break;
      case AuthStatus.LOGGED_IN:
        return FutureBuilder(
          future: widget.auth.getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
          if(user.hasData){
            if (currUser.fbUser.uid.length > 0 && currUser != null) {
              switch(currUser.fsUser.data["Usertype"]){
                case 1: return new ContractorHome(
                    auth: widget.auth,
                    logoutCallback: logoutCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor
                  );
                  break;
                case 2: return new ProductionHome(
                    auth: widget.auth,
                    logoutCallback: logoutCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor
                  );
                        break;
                
                case 3: return new DeliveryHome(
                    auth: widget.auth,
                    logoutCallback: logoutCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor
                  );
                        break;
                case 99: return new AdminHome(
                    auth:widget.auth,
                    logoutCallback: logoutCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor
                  );
                  break;
                case 999: return new AdminHome(
                    auth:widget.auth,
                    logoutCallback: logoutCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor
                  );
                  break;
                case -1: 
                  return new Login(auth: widget.auth, loginCallback:  loginCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor);
                  break;
                default:
                  logoutCallback();
                  return new Login(auth: widget.auth, loginCallback:  loginCallback,
                    fontColor: fontColor,
                    accentFontColor: accentFontColor,
                    accentColor: accentColor);
                  break;
              }
              
            } else{
              return buildWaitingScreen();
            }
          }else{
            return buildWaitingScreen();
          }
        }
      );
     default: return buildWaitingScreen();
              break;
    }
  }
  
}