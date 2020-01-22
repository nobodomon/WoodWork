import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/AdminPages/createUser.dart';
import 'package:woodwork/AdminPages/home.dart';
import 'package:woodwork/AdminPages/manageUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class AdminHome extends StatefulWidget{
  AdminHome({this.auth, this.logoutCallback, this.currUser});
  
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final UserProfile currUser;
  @override
  State<StatefulWidget> createState() => _AdminHomeState();

}

class _AdminHomeState extends State<AdminHome>{
  PageController pageController = new PageController(keepPage: true);
  @override
  void initState(){
    super.initState();
  }
  int _currentIndex = 0;

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
     pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
   });
  }

  final List<Widget> children = [
    new CreateUser(auth: new Auth()),
    new AHome(auth: new Auth()),
    new ManageUser(auth: new Auth(),),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0,
        title: new Text("AdminHome", style: new TextStyle(color: Colors.white),),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: ()=> showDialog(
              context: context,
              child: CommonWidgets.logoutDialog(context, widget.logoutCallback),
            )
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        children: children,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
        curve: Curves.easeInOut,
        activeColor: Colors.blueGrey[700],
        currentIndex: _currentIndex,
        onTap: (index){
          onTabTapped(index);
        },
        items: [
          TitledNavigationBarItem(title: "Add User", icon: Icons.person_add),
          TitledNavigationBarItem(title: "Home", icon: Icons.home),
          TitledNavigationBarItem(title: "Manage Users", icon: Icons.subject),
        ],
      ),
    );
  }
  
}