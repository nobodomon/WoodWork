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
    new CallService(),
    new CHome(auth: new Auth()),
    new Orders(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey[600],
        elevation: 0,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.exit_to_app),
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
      body: new PageView(
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
          TitledNavigationBarItem(title: "Scan", icon: Icons.filter_center_focus),
          TitledNavigationBarItem(title: "Home", icon: Icons.home),
          TitledNavigationBarItem(title: "Orders", icon: Icons.list),

        ],
      ),
    );
  }
  
}