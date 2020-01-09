import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/rootPage.dart';

class cHome extends StatefulWidget{
  cHome({this.auth});
  BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> cHomeState();
}


class cHomeState extends State<cHome>{
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: Auth().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
    // TODO: implement build
      if(!user.hasData){
        return  new Scaffold(
          body: Center(
            child: new Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
              color: Colors.white,
            ),
          ),
        );
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
          new ExpansionTile(
            title: new Text("Orders"),
            leading: new Icon(Icons.list),
            children: <Widget>[
              new ListTile(
                title: new Text("Complete Orders"),
                trailing: new Text("#"),
              ),
              new ListTile(
                title: new Text("Incomplete Orders"),
                trailing: new Text("#"),
              )
            ],
          )
        ],
      ),
    );
      }
  });
  }
}