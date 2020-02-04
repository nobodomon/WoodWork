import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/CommonWIdgets/EditProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';
import 'package:woodwork/DeliveryPages/DeliverPage.dart';
import 'package:woodwork/DeliveryPages/PickupPage.dart';

class DeliveryHome extends StatefulWidget{
  DeliveryHome({this.auth,this.logoutCallback, this.fontColor,this.accentFontColor, this.accentColor});
  final Auth auth;
  final VoidCallback logoutCallback;
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;

  @override
  State<StatefulWidget> createState() => _DeliveryHomeState();

}

class _DeliveryHomeState extends State<DeliveryHome>{
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
        title: new Text("DeliveryHome",
        style: new TextStyle(
          color: widget.fontColor
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
              child: CommonWidgets.logoutDialog(context, widget.logoutCallback,false),
            )
          )
        ],
      ),
      body: new PageView(
        controller: pageController,
        children: <Widget>[
          PickUpPage(fontColor: widget.fontColor, accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,),
          DeliverPage(fontColor: widget.fontColor, accentFontColor: widget.accentFontColor, accentColor: widget.accentColor,)
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: new TitledBottomNavigationBar(
        curve: Curves.easeInOut,
        activeColor: Colors.blueGrey[700],
        currentIndex: _currentIndex,
        items: [
          TitledNavigationBarItem(title: "Pick-Up", icon: Icons.camera),
          TitledNavigationBarItem(title: "Deliver", icon: Icons.camera),
        ],
        onTap: (index){
          onTabTapped(index);
        },
      ),
    );
  }
  
}