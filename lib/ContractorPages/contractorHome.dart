import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:woodwork/ContractorPages/scan.dart';

class ContractorHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ContractorHomeState();

}

class _ContractorHomeState extends State<ContractorHome>{
  int _currentIndex = 0;
  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
  }
  final List<Widget> children = [
    new Scan("Scan"),
    new Scan("Home"),
    new Scan("Orders")
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text("ContractorHome"),
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