import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/AdminPages/createUser.dart';
import 'package:woodwork/AdminPages/home.dart';
import 'package:woodwork/AdminPages/manageUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';

class AdminHome extends StatefulWidget{
  AdminHome({this.auth, this.logoutCallback, this.currUser});
  
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  UserProfile currUser;
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
    new aHome(auth: new Auth()),
    new ManageUser(auth: new Auth()),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0,
        title: new Text("AdminHome"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.exit_to_app),
            onPressed: ()=> showDialog(
              context: context,
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  margin: new EdgeInsets.all(75),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new ListTile(
                        title: new Text("Log-out"),
                        subtitle: new Text("Are you sure you want to log out?")
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new FlatButton(
                            child: new Text("Confirm"),
                            onPressed: (){
                              widget.logoutCallback();
                              Navigator.of(context).pop();
                            }
                          ),
                          new FlatButton(
                            child: new Text("Cancel"),
                            onPressed: ()=>{Navigator.of(context).pop()}
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
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