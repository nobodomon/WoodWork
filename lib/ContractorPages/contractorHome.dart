import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/ContractorPages/callService.dart';
import 'package:woodwork/ContractorPages/home.dart';
import 'package:woodwork/ContractorPages/orders.dart';

class ContractorHome extends StatefulWidget{
  ContractorHome({this.auth, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  @override
  State<StatefulWidget> createState() => _ContractorHomeState();

}

class _ContractorHomeState extends State<ContractorHome>{
  @override
  void initState(){
    super.initState();
  }
  int _currentIndex = 0;
  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }
  final List<Widget> children = [
    new callService(),
    new cHome(auth: new Auth()),
    new Orders(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: widget.logoutCallback,
          )
        ],
      ),
      body: children[_currentIndex],
      bottomNavigationBar: TitledBottomNavigationBar(
        curve: Curves.easeInOut,
        activeColor: Colors.blueGrey[700],
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