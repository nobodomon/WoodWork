import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/AdminPages/viewUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';

class AHome extends StatefulWidget{
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  AHome({this.auth, this.accentFontColor, this.accentColor, this.fontColor,});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> AHomeState();

}

class AHomeState extends State<AHome> with SingleTickerProviderStateMixin{
  TabController controller;
  double scaffoldHeight;

  @override
  void initState(){
    controller = new TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scaffoldHeight = MediaQuery.of(context).size.height;
    return new FutureBuilder(
      future: widget.auth.getCurrentUser(),
      builder: (BuildContext context,AsyncSnapshot<UserProfile> user){
        if(user.hasData){
          return new Scaffold(
            backgroundColor: widget.accentColor,
            body: ListView(
              children: <Widget>[
                Container(
                  color: widget.accentColor,
                  child: new ListTile(
                    
                    title: new Text("Welcome " + user.data.fsUser.data['Name'],
                    style: TextStyle(color: widget.fontColor),),
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  controller: controller,
                  tabs: <Widget>[
                    Tab(
                      text: "Users",
                    ),
                    Tab(
                      text: "S.admins",
                    ),
                    Tab(
                      text: "Admins",
                    ),
                    Tab(
                      text: "Contractors",
                    ),
                    Tab(
                      text: "Production",
                    ),
                    Tab(
                      text: "Delivery",
                    ),
                    Tab(
                      text: "Deleted",
                    )
                  ],
                ),
                
            dashBoardContainer(context),
              ],
            ),
          );
        }else{
          return CommonWidgets.pageLoadingScreen(context);
        }
      }
    );
  }

  Widget dashBoardContainer(BuildContext context){
    return Container(
      width: double.maxFinite,
      height: scaffoldHeight/3,
      decoration: BoxDecoration(
        gradient: CommonWidgets.mainGradient
      ),
      child: overviewPanels(),
    );
  }

  Widget overviewPanels(){
    Auth accessor = new Auth();
    return FutureBuilder(
      future: accessor.getAllUsersRegardless(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users){
        if(users.hasData){
          //Usertypes, 99 -> Admin, 999 -> S.Admin, 1 -> Contractor, 2 -> Production, 3 -> Delivery
          int userCount = users.data.documents.length;
          DocumentSnapshot user;
          try{
            user = users.data.documents.reversed.last;
          }catch(e){
            user = null;
          }
          List<DocumentSnapshot> sAdmins = [];
          sAdmins.addAll(users.data.documents.reversed);
          sAdmins.retainWhere((user) => user.data["Usertype"] == 999);
          DocumentSnapshot sAdminUser;
          try{
            sAdminUser = sAdmins.last;
          }catch(e){
            sAdminUser = null;
          }
          int sAdminCount = sAdmins.length;
          List<DocumentSnapshot> admins = [];
          admins.addAll(users.data.documents.reversed);
          admins.retainWhere((user) => user.data["Usertype"] == 99);
          int adminCount = admins.length;
          DocumentSnapshot adminUser;
          try{
            adminUser = admins.last;
          }catch(e){
            adminUser = null;
          }
          List<DocumentSnapshot> contractors = [];
          contractors.addAll(users.data.documents.reversed);
          contractors.retainWhere((user) => user.data["Usertype"] == 1);
          int contractorCount = contractors.length;
          DocumentSnapshot contractorUser;
          try{
            contractorUser = contractors.last;
          }catch(e){
            contractorUser = null;
          }
          List<DocumentSnapshot> productions = [];
          productions.addAll(users.data.documents.reversed);
          productions.retainWhere((user) => user.data["Usertype"] == 2);
          int productionCount = productions.length;
          DocumentSnapshot productionUser;
          try{
            productionUser = productions.last;
          }catch(e){
            productionUser = null;
          }
          List<DocumentSnapshot> deliveries = [];
          deliveries.addAll(users.data.documents.reversed);
          deliveries.retainWhere((user) => user.data["Usertype"] == 3);
          int deliveryCount = deliveries.length;
          DocumentSnapshot deliveryUser;
          try{
            deliveryUser = deliveries.last;
          }catch(e){
            deliveryUser = null;
          }
          List<DocumentSnapshot> deleted = [];
          deleted.addAll(users.data.documents.reversed);
          deleted.retainWhere((user) => user.data["Usertype"] == -1);
          int deletedCount = deleted.length;
          DocumentSnapshot deletedUser;
          try{
            deletedUser = deleted.last;
          }catch(e){
            deletedUser = null;
          }
          return Container(
            height: scaffoldHeight/3,
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                overviewPanel("All users", userCount, lastUser: user, panelColor: CommonWidgets.mapUserRoleToColor(-1)), 
                overviewPanel("Super Admin", sAdminCount, lastUser: sAdminUser, panelColor: CommonWidgets.mapUserRoleToColor(999)), 
                overviewPanel("Admin", adminCount, lastUser: adminUser, panelColor: CommonWidgets.mapUserRoleToColor(99)), 
                overviewPanel("Contractors", contractorCount, lastUser: contractorUser, panelColor: CommonWidgets.mapUserRoleToColor(1)), 
                overviewPanel("Productions", productionCount, lastUser: productionUser, panelColor: CommonWidgets.mapUserRoleToColor(2)),  
                overviewPanel("Delivery", deliveryCount, lastUser: deliveryUser, panelColor: CommonWidgets.mapUserRoleToColor(3)),
                overviewPanel("Deleted", deletedCount, lastUser: deletedUser, panelColor: CommonWidgets.mapUserRoleToColor(-1)), 
              ]
            ),
          );
        }else{
          return Container(
            height: scaffoldHeight/3,
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
    });
    
  }

  Widget overviewPanel(String userType, int userCount, {DocumentSnapshot lastUser, Color panelColor}){
    if(lastUser != null || userCount > 0){
      Color userColor = CommonWidgets.mapUserRoleToColor(lastUser.data['Usertype']);
      return Container(
        decoration: BoxDecoration(
          gradient: CommonWidgets.mainGradient,
          borderRadius: BorderRadius.circular(30),
          border: new Border.all(color: userColor, width: 2) ,
          boxShadow: <BoxShadow>[
            BoxShadow(color: userColor,blurRadius: 7 ,spreadRadius: 1)
          ]
        ),
        margin: EdgeInsets.all(15),
        height: scaffoldHeight/8,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              height: scaffoldHeight/8,
              child: ListTile(
                title: Text(
                  userType,
                  style: TextStyle(
                    fontSize: 42,
                    color:widget.fontColor
                  ),
                ),
                subtitle: Text("Latest created user",
                  style: TextStyle(
                    color:widget.fontColor
                  ),),
                trailing: Text(userCount.toString() + " Users", style: TextStyle(color: widget.fontColor)),
              ),
            ),
            Divider(),
            userOverview(userCount, lastUser),
          ],
        ),
      );
    }else{
      return Container(
        decoration: BoxDecoration(
          gradient: CommonWidgets.mainGradient,
          borderRadius: BorderRadius.circular(30),
          border: new Border.all(color: panelColor, width: 2) ,
          boxShadow: <BoxShadow>[
            BoxShadow(color: panelColor,blurRadius: 7 ,spreadRadius: 1)
          ]
        ),
        margin: EdgeInsets.all(15),
        height: scaffoldHeight/8,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              height: scaffoldHeight/8,
              child: ListTile(
                title: Text(
                  userType,
                  style: TextStyle(
                    fontSize: 42,
                    color:widget.fontColor
                  ),
                ),
                subtitle: Text("Latest created user",
                  style: TextStyle(
                    color:widget.fontColor
                  ),),
                trailing: Text(userCount.toString() + " Users", style: TextStyle(color: widget.fontColor)),
              ),
            ),
            Divider(),
            userOverview(userCount, lastUser, panelColor: panelColor),
          ],
        ),
      );
    }
  }

  Widget userOverview(int userCount, DocumentSnapshot lastUser, {Color panelColor}){
    
    if(userCount > 0){
      List<String> nameSplit = lastUser.data['Name'].split(' ');
      String reFormatname = "";
      if(nameSplit.length > 1){
        reFormatname = lastUser.data['Name'].split(' ')[0].substring(0,1).toUpperCase() + lastUser.data['Name'].split(' ')[1].substring(0,1).toUpperCase();
      }else{
        reFormatname = lastUser.data['Name'].split(' ')[0].substring(0,1).toUpperCase();
      }

      Color userColor = CommonWidgets.mapUserRoleToColor(lastUser.data['Usertype']);
      String lastlogin = lastUser.data['Last-login'].toString();
      if(lastlogin == "null"){
        lastlogin = "Not login yet.";
      }
      return Container(
        padding: EdgeInsets.all(15),
        height: scaffoldHeight/8,
        child: ListTile(
          subtitle: Text("Last login: " + lastlogin.toString(), style: TextStyle(color: widget.fontColor)),
          title: new Text(lastUser.data['Name'], style: TextStyle(color: widget.fontColor)),
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
                          ViewUser(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,email: lastUser.documentID, userType: lastUser.data['Usertype'])));
            }),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewUser(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,email: lastUser.documentID, userType: lastUser.data['Usertype'])));
          },
        ),
      );
    }else{
       return Container(
        padding: EdgeInsets.all(15),
        height: scaffoldHeight/8,
         child: ListTile(
            title: new Text("No user with this role yet!", style: TextStyle(color:widget.fontColor),),
            leading: new Container(
              alignment: Alignment.center,
              width: 45,
              height: 45,
              decoration: new BoxDecoration(
                border: new Border.all(color: panelColor, width: 2) ,
                  color:Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black87, spreadRadius: 0.75, blurRadius: 1)
                  ]),
              child: new Text(
                "?",
                style: new TextStyle(fontSize: 21),
              ),
            ),
          ),
       );
    }
  }
}