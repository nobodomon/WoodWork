import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/AdminPages/createUser.dart';
import 'package:woodwork/AdminPages/home.dart';
import 'package:woodwork/AdminPages/manageUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class AdminHome extends StatefulWidget {
  AdminHome(
      {this.auth,
      this.logoutCallback,
      this.currUser,
      this.fontColor,
      this.accentFontColor,
      this.accentColor});
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final UserProfile currUser;
  @override
  State<StatefulWidget> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  PageController pageController = new PageController(keepPage: true);
  @override
  void initState() {
    super.initState();
  }

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.accentColor,
      appBar: new AppBar(
        backgroundColor: widget.accentColor,
        elevation: 0,
        title: new Text(
          "AdminHome",
          style: new TextStyle(color: widget.fontColor),
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () => showDialog(
                    context: context,
                    child: CommonWidgets.logoutDialog(
                        context, widget.logoutCallback),
                  ))
        ],
      ),
      body: PageView(
        controller: pageController,
        children: <Widget>[
          new CreateUser(
              auth: new Auth(),
              fontColor: widget.fontColor,
              accentFontColor: widget.accentFontColor,
              accentColor: widget.accentColor),
          new AHome(
              auth: new Auth(),
              fontColor: widget.fontColor,
              accentFontColor: widget.accentFontColor,
              accentColor: widget.accentColor),
          new ManageUser(
              auth: new Auth(),
              fontColor: widget.fontColor,
              accentFontColor: widget.accentFontColor,
              accentColor: widget.accentColor),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
        curve: Curves.easeInOut,
        activeColor: widget.accentColor,
        currentIndex: _currentIndex,
        onTap: (index) {
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
