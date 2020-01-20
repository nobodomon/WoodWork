import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/AdminPages/searchUser.dart';
import 'package:woodwork/AdminPages/viewUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ManageUser extends StatefulWidget {
  ManageUser({this.auth});
  Auth auth;
  UserProfile currUser;
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
  }
  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildsetState(() {
      return new StreamBuilder(
      stream: widget.auth.getAllUsers().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users) {
        if (users.hasData && users.data.documents.length != 0) {
          return new Scaffold(
            floatingActionButton: new Container(
              child: new IconButton(
                icon: new Icon(Icons.search, color: Colors.white),
                onPressed: ()=> Navigator.push(context, new MaterialPageRoute(builder: ((context)=> SearchUser()))),
              ),
              width: 45,
              height: 45,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black87,
                    spreadRadius: 0.75,
                    blurRadius: 1
                  )
                ],
                gradient: new LinearGradient(
                  colors: [Colors.blueGrey[700],Colors.blueGrey[400]],
                )
              ),
            ),
            backgroundColor: Colors.transparent,
            body: generateAllUsersList(users.data),
          );
        } else {
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  ListView generateAllUsersList(QuerySnapshot users){
    return new ListView.builder(
    itemCount: users.documents.length,
    itemBuilder: (context, index) {
      String name = users.documents[index].data['Name'];
      int userType = users.documents[index].data['Usertype'];
      String email = users.documents[index].documentID;
      String userTypeLong = "";
      Color userColor;
      Color userAvatarColor;
      switch (userType) {
        case 1:
          userTypeLong = "Contractor";
          userColor = Colors.yellow[200];
          userAvatarColor = Colors.yellow[400];
          break;
        case 2:
          userTypeLong = "Production";
          userColor = Colors.red[200];
          userAvatarColor = Colors.red[400];
          break;
        case 3:
          userTypeLong = "Delivery";
          userColor = Colors.blue[200];
          userAvatarColor = Colors.blue[400];
          break;
        case 99:
          userTypeLong = "Admin";
          userColor = Colors.green[200];
          userAvatarColor = Colors.green[400];
          break;
        case 999:
          userTypeLong = "S.Admin";
          userColor = Colors.teal[200];
          userAvatarColor = Colors.teal[400];
          break;
        case -1:
          userTypeLong = "Invalid type!";
          break;
      }
      return Container(
        color: userAvatarColor,
        child: ListTile(
          leading: new Container(
            alignment: Alignment.center,
            width: 45,
            height: 45,
            decoration: new BoxDecoration(
              color: userColor,
              shape: BoxShape.circle,
              boxShadow: [
                new BoxShadow(
                  color: Colors.black87,
                  spreadRadius: 0.75,
                  blurRadius: 1
                )
              ]
            ),
            child: new Text(
              userType.toString(),
              style: new TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 21
              ),
            ),
          ),
          title: new Text(name),
          subtitle: new Text(userTypeLong),
          trailing: new IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewUser(
                            email: email, userType: userType)));
              }),
        ),
      );
    });
  }

  Future<int> getCurrUserAdminLevel() async {
    UserProfile currUserAdmin = await widget.auth.getCurrentUser();
    return currUserAdmin.fsUser.data['Usertype'];
  }
}
