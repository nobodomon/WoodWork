import 'package:flutter/material.dart';

class cHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> cHomeState();
}


class cHomeState extends State<cHome>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            title: new Text("Welcome" + "user"),
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
}