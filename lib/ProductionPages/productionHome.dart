import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/CommonWIdgets/EditProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/ProductionPages/PHome.dart';
import 'package:woodwork/ProductionPages/Scan.dart';
import 'package:woodwork/ProductionPages/incomingOrders.dart';

class ProductionHome extends StatefulWidget{
  ProductionHome({this.auth,this.logoutCallback, this.fontColor,this.accentFontColor, this.accentColor});
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  final Auth auth;
  final VoidCallback logoutCallback;
  @override
  State<StatefulWidget> createState() => _ProductionHomeState();

}

class _ProductionHomeState extends State<ProductionHome>{
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
        title: new Text("ProductionHome",
        style: new TextStyle(
          color: widget.accentFontColor
        ),),
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
          Scan(fontColor: widget.fontColor, accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,),
          PHome(),
          IncomingOrders(fontColor: widget.fontColor, accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,)
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: new TitledBottomNavigationBar(
        curve: Curves.easeInOut,
        activeColor: widget.accentColor,
        currentIndex: _currentIndex,
        items: [
          TitledNavigationBarItem(title: "Scan", icon: Icons.camera),
          TitledNavigationBarItem(title: "Home", icon: Icons.home),
          TitledNavigationBarItem(title: "Incoming Orders", icon: Icons.list),
        ],
        onTap: (index){
          onTabTapped(index);
        },
      ),
    );
  }
  
}