import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/CommonWIdgets/EditProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ContractorPages/ServicePage.dart';
import 'package:woodwork/ContractorPages/home.dart';
import 'package:woodwork/ContractorPages/orders.dart';

class ContractorHome extends StatefulWidget{
  ContractorHome({this.auth, this.logoutCallback, this.fontColor,this.accentFontColor, this.accentColor});
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  @override
  State<StatefulWidget> createState() => _ContractorHomeState();

}

class _ContractorHomeState extends State<ContractorHome>{
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: widget.accentColor,
        elevation: 0,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.settings),
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EditProfile(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor, auth: widget.auth, logoutCallback: widget.logoutCallback)),
                  )),
          new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: ()=> showDialog(
              context: context,
              child: CommonWidgets.logoutDialog(context, widget.logoutCallback, false),
            )
          )
        ],
      ),
      body: new PageView(
        controller: pageController,
        children: <Widget>[
          new ServicePage(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor),
          new CHome(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor, auth: widget.auth),
          new Orders(fontColor: widget.fontColor,accentFontColor: widget.accentFontColor, accentColor: widget.accentColor),
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
        onTap: (index){
          onTabTapped(index);
        },
        items: [
          TitledNavigationBarItem(title: "Scan", icon: Icons.filter_center_focus),
          TitledNavigationBarItem(title: "Home", icon: Icons.home),
          TitledNavigationBarItem(title: "Orders", icon: Icons.list),

        ],
      ),
    );
  }
  
}