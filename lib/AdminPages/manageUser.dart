import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/AdminPages/viewUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ManageUser extends StatefulWidget {
  ManageUser({this.auth, this.currUser, this.accentFontColor, this.accentColor, this.fontColor});
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  final Auth auth;
  final UserProfile currUser;
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  bool searchVisible = false;
  TextEditingController controller = new TextEditingController();
  Gradient currSearchGrad;
  List<Gradient> searchGradient = [
    CommonWidgets.subGradient,
    CommonWidgets.mainGradient
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
                  gradient: currSearchGrad),
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
        color: Colors.white54,
        child: CommonWidgets.commonTextFormField(Icons.search, "Search...", controller, Colors.black, widget.accentFontColor)
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
              userTypeLong = "Invalid/Deleted user!";
              userColor = Colors.black;
              userAvatarColor = [Colors.black, Colors.white];
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

  Container showUserTile(String name, int userType, String email, String userTypeLong, Color userColor, List<Color> userAvatarColor) {
    List<String> nameSplit = name.split(' ');
    String reFormatname = "";
    if(nameSplit.length > 1){
      reFormatname = name.split(' ')[0].substring(0,1).toUpperCase() + name.split(' ')[1].substring(0,1).toUpperCase();
    }else{
      reFormatname = name.split(' ')[0].substring(0,1).toUpperCase();
    }
    return Container(
      margin: EdgeInsets.fromLTRB(4.5, 2.25, 4.5, 2.25),
      decoration: new BoxDecoration(
          color: widget.accentColor,
          borderRadius: BorderRadius.circular(5),
          border: new Border.all(color: userColor, width: 1.5)),
      child: ListTile(
        dense: true,
        leading: new Container(
          alignment: Alignment.center,
          width: 45,
          height: 45,
          decoration: new BoxDecoration(
            border: new Border.all(color: userColor, width: 2) ,
              color:Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                new BoxShadow(
                    color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
              ]),
          child: new Text(
            reFormatname,
            style: new TextStyle(fontSize: 21),
          ),
        ),
        title: new Text(name, style: new TextStyle(color:widget.fontColor),),
        subtitle: new Text(userTypeLong, style: new TextStyle(color:widget.fontColor),),
        trailing: new IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: userColor,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewUser(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,email: email, userType: userType)));
            }),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ViewUser(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,email: email, userType: userType)));
        },
      ),
    );
  }

  Future<int> getCurrUserAdminLevel() async {
    UserProfile currUserAdmin = await widget.auth.getCurrentUser();
    return currUserAdmin.fsUser.data['Usertype'];
  }
}
