import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/AdminPages/viewUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ManageUser extends StatefulWidget {
  ManageUser({this.auth, this.currUser});
  final Auth auth;
  final UserProfile currUser;
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  bool searchVisible = false;
  TextEditingController controller = new TextEditingController();
  List<Color> currSearchGrad;
  List<List<Color>> searchGradient = [
    [Colors.blueGrey[700], Colors.blueGrey[400]],
    [Colors.red[700], Colors.red[400]],
  ];
  String filter;
  @override
  void initState() {
    super.initState();
    currSearchGrad = searchGradient[0];
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: widget.auth.getAllUsers().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users) {
        if (users.hasData && users.data.documents.length != 0) {
          return new Scaffold(
            floatingActionButton: new Container(
              child: new IconButton(
                icon: new Icon(Icons.search, color: Colors.white),
                onPressed: () => setState(() {
                  if (searchVisible) {
                    filter = "";
                    controller.clear();
                    searchVisible = false;
                    currSearchGrad = searchGradient[0];
                  } else {
                    searchVisible = true;
                    currSearchGrad = searchGradient[1];
                  }
                }),
              ),
              width: 45,
              height: 45,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black87,
                        spreadRadius: 0.75,
                        blurRadius: 1)
                  ],
                  gradient: new LinearGradient(
                    colors: currSearchGrad,
                  )),
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              children: <Widget>[
                showSearchBar(context),
                Expanded(child: generateAllUsersList(users.data)),
              ],
            ),
          );
        } else {
          return CommonWidgets.pageLoadingScreen(context);
        }
      },
    );
  }

  Visibility showSearchBar(BuildContext context) {
    return new Visibility(
      visible: searchVisible,
      child: Container(
        margin: EdgeInsets.all(4.5),
        color: Colors.white,
        child: ListTile(
          title: new TextFormField(
            autofocus: true,
            controller: controller,
            decoration: new InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueGrey[600], width: 2.0)),
                hintText: "Search..."),
          ),
          leading: new Icon(Icons.search),
        ),
      ),
    );
  }

  ListView generateAllUsersList(QuerySnapshot users) {
    return new ListView.builder(
        itemCount: users.documents.length,
        itemBuilder: (context, index) {
          String name = users.documents[index].data['Name'];
          int userType = users.documents[index].data['Usertype'];
          String email = users.documents[index].documentID;
          String userTypeLong = "";
          Color userColor;
          List<Color> userAvatarColor;
          switch (userType) {
            case 1:
              userTypeLong = "Contractor";
              userColor = Colors.yellow[400];
              userAvatarColor = [Colors.yellow[100], Colors.yellow[300]];
              break;
            case 2:
              userTypeLong = "Production";
              userColor = Colors.red[400];
              userAvatarColor = [Colors.red[100], Colors.red[300]];
              break;
            case 3:
              userTypeLong = "Delivery";
              userColor = Colors.blue[400];
              userAvatarColor = [Colors.blue[100], Colors.blue[300]];
              break;
            case 99:
              userTypeLong = "Admin";
              userColor = Colors.green[400];
              userAvatarColor = [Colors.green[100], Colors.green[300]];
              break;
            case 999:
              userTypeLong = "S.Admin";
              userColor = Colors.teal[400];
              userAvatarColor = [Colors.teal[100], Colors.teal[300]];
              break;
            case -1:
              userTypeLong = "Invalid type!";
              break;
          }
          if (filter == null || filter.isEmpty) {
            return showUserTile(name, userType, email, userTypeLong, userColor,
                userAvatarColor);
          } else if (users.documents[index].data['Name']
                  .toString()
                  .toLowerCase()
                  .contains(filter.toLowerCase()) ||
              users.documents[index].data['Usertype']
                  .toString()
                  .contains(filter) ||
              CommonWidgets.mapUserRoleToLongName(
                      users.documents[index].data['Usertype'])
                  .toString()
                  .toLowerCase()
                  .contains(filter)) {
            return showUserTile(name, userType, email, userTypeLong, userColor,
                userAvatarColor);
          } else {
            return Container();
          }
        });
  }

  Container showUserTile(String name, int userType, String email,
      String userTypeLong, Color userColor, List<Color> userAvatarColor) {
    return Container(
      margin: EdgeInsets.fromLTRB(4.5, 2.25, 4.5, 2.25),
      color: userColor,
      child: ListTile(
        leading: new Container(
          alignment: Alignment.center,
          width: 45,
          height: 45,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: userAvatarColor,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                new BoxShadow(
                    color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
              ]),
          child: new Text(
            userType.toString(),
            style: new TextStyle(fontStyle: FontStyle.italic, fontSize: 21),
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
                      builder: (context) =>
                          ViewUser(email: email, userType: userType)));
            }),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewUser(
                        email: email,
                        userType: userType,
                      )));
        },
      ),
    );
  }

  Future<int> getCurrUserAdminLevel() async {
    UserProfile currUserAdmin = await widget.auth.getCurrentUser();
    return currUserAdmin.fsUser.data['Usertype'];
  }
}
