import 'package:flutter/material.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class CHome extends StatefulWidget{
  CHome({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> CHomeState();
}


class CHomeState extends State<CHome>{
  FirestoreAccessors _firestoreAccessors;
  @override
  void initState() {
    _firestoreAccessors = new FirestoreAccessors();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: Auth().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
      if(!user.hasData){
        return CommonWidgets.pageLoadingScreen(context);
      }else{
      return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              new Container(
                color: Colors.blueGrey[700],
                height: 400,
              ),
              new Container(
                  alignment: Alignment.bottomCenter,
                  color: Colors.blueGrey[900],
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text(
                      "Contractor's Home",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 24
                      ),
                    ),
                  ),
                ),
            ]
          ),
          new ListTile(
            leading: new Icon(Icons.person),
            title: new Text("Welcome " + user.data.fsUser.data["Name"]),
          ),
          ordersOverView(),
        ],
      ),
    );
      }
  });
  }

  Widget ordersOverView(){
    return FutureBuilder(
      future: _firestoreAccessors.getOverViewNumbers(),
      builder: (BuildContext context, AsyncSnapshot<List<int>> numbers){
        if(numbers.hasData){
          return new ExpansionTile(
            title: new Text(numbers.data[2].toString() + " Orders"),
            leading: new Icon(Icons.list),
            children: <Widget>[
              new ListTile(
                title: new Text("Complete Orders"),
                trailing: new Text(numbers.data[0].toString()),
              ),
              new ListTile(
                title: new Text("Incomplete Orders"),
                trailing: new Text(numbers.data[1].toString()),
              )
            ],
          );
        }else{
          return LinearProgressIndicator();
        }
      },
    );
  }
}