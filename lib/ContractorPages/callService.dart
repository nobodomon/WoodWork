import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class callService extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new callServiceState();
}

class callServiceState extends State<callService>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.blueGrey[700],
      body: new Center(
        child: new Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          margin: new EdgeInsets.all(75),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: Icon(Icons.phone, color: Colors.blueGrey[700],),
                title: new Text("Call for service"),
              ),
              new Divider(),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new GradientButton(
                  increaseWidthBy: double.infinity,
                  gradient: Gradients.taitanum,
                  child: new Text("Call"),
                  callback: ()=>{
                    showDialog(
                      context: context,
                      child: Center(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                          margin: new EdgeInsets.all(75),
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                title: new Text("Confirm call for service"),
                                subtitle: new Text("This will call production company for servicing.")
                              ),
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new FlatButton(
                                    child: new Text("Confirm"),
                                    onPressed: (){},
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
                  },
                ),
              )
            ],
          ),
        ))
      ,);
  }
}