import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                dashBoardContainer(context),
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
                      text: "Delivery",
                    ),
                    Tab(
                      text: "Production",
                    ),
                    Tab(
                      text: "Deleted",
                    )
                  ],
                ),
                overviewPanels(),
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
    );
  }

  Widget overviewPanels(){
    Auth accessor = new Auth();
    return FutureBuilder(
      future: accessor.getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users){
        if(users.hasData){
          //Usertypes, 99 -> Admin, 999 -> S.Admin, 1 -> Contractor, 2 -> Production, 3 -> Delivery
          int userCount = users.data.documents.length;
          List<DocumentSnapshot> sAdmins = [];
          sAdmins.addAll(users.data.documents);
          sAdmins.retainWhere((user) => user.data["Usertype"] == 999);
          int sAdminCount = sAdmins.length;
          List<DocumentSnapshot> admins = [];
          admins.addAll(users.data.documents);
          admins.retainWhere((user) => user.data["Usertype"] == 99);
          int adminCount = admins.length;
          List<DocumentSnapshot> contractors = [];
          contractors.addAll(users.data.documents);
          contractors.retainWhere((user) => user.data["Usertype"] == 1);
          int contractorCount = contractors.length;
          List<DocumentSnapshot> productions = [];
          productions.addAll(users.data.documents);
          productions.retainWhere((user) => user.data["Usertype"] == 2);
          int productionCount = productions.length;
          List<DocumentSnapshot> deliveries = [];
          deliveries.addAll(users.data.documents);
          deliveries.retainWhere((user) => user.data["Usertype"] == 3);
          int deliveryCount = deliveries.length;
          List<DocumentSnapshot> deleted = [];
          deleted.addAll(users.data.documents);
          deleted.retainWhere((user) => user.data["Usertype"] == -1);
          int deletedCount = deleted.length;

          return Container(
            height: scaffoldHeight/3,
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                overviewPanel("All users", userCount), 
                overviewPanel("Super Admin", sAdminCount), 
                overviewPanel("Admin", adminCount), 
                overviewPanel("Contractors", contractorCount), 
                overviewPanel("Productions", productionCount), 
                overviewPanel("Delivery", deliveryCount), 
                overviewPanel("Deleted", deletedCount), 
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

  Widget overviewPanel(String userType, int userCount, DocumentSnapshot lastUser){
    return Container(
      margin: EdgeInsets.all(15),
      height: scaffoldHeight/8,
      width: double.maxFinite,
      color: widget.accentFontColor,
      child: ListTile(
        title: Text(
          userType,
          style: TextStyle(
            color:widget.fontColor
          ),
        ),
        trailing: Text(userCount.toString()),
      ),
    );
  }
}