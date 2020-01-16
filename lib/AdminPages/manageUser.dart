import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
      stream: widget.auth.getAllUsers().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users) {
        if (users.hasData && users.data.documents.length > 0) {
          return new Scaffold(
            backgroundColor: Colors.transparent,
            body: new ListView.builder(
                itemCount: users.data.documents.length,
                itemBuilder: (context, index) {
                  String name = users.data.documents[index].data['Name'];
                  int userType = users.data.documents[index].data['Usertype'];
                  String email = users.data.documents[index].documentID;
                  String userTypeLong = "";
                  Color userColor;
                  switch (userType) {
                    case 1:
                      userTypeLong = "Contractor";
                      userColor = Colors.yellow[300];
                      break;
                    case 2:
                      userTypeLong = "Production";
                      userColor = Colors.red[300];
                      break;
                    case 3:
                      userTypeLong = "Delivery";
                      userColor = Colors.blue[400];
                      break;
                    case 99:
                      userTypeLong = "Admin";
                      userColor = Colors.green[400];
                      break;
                    case 999:
                      userTypeLong = "S.Admin";
                      userColor = Colors.teal[400];
                      break;
                    case -1:
                      userTypeLong = "Invalid type!";
                      break;
                  }
                  return Container(
                    color: userColor,
                    child: ListTile(
                      leading: new Container(
                        alignment: Alignment.center,
                        width: 60,
                        height: 60,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
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
                }),
          );
        } else {
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  Future<int> getCurrUserAdminLevel() async {
    UserProfile currUserAdmin = await widget.auth.getCurrentUser();
    return currUserAdmin.fsUser.data['Usertype'];
  }
}
