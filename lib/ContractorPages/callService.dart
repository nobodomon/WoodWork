import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/DataAccessors/firestoreAccessors.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class CallService extends StatefulWidget{
  
  final Color fontColor;
  final Color accentFontColor;
  final Color accentColor;

  const CallService({Key key, this.fontColor, this.accentFontColor, this.accentColor});
  @override
  State<StatefulWidget> createState() => new CallServiceState();
}

class CallServiceState extends State<CallService>{
  FirestoreAccessors _firestoreAccessors;
  @override
  void initState() {
    _firestoreAccessors = new FirestoreAccessors();
    super.initState();
  }
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: isLoading,
          child: CommonWidgets.pageLoadingScreen(context)
        ),
        new Scaffold(
          backgroundColor: widget.accentColor,
          body: new Center(
            child: new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              margin: new EdgeInsets.all(75),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: Icon(Icons.phone, color: widget.accentFontColor,),
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
                                        onPressed: (){
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Navigator.of(context).pop();
                                          _firestoreAccessors.createOrder().then((x){
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                          
                                        },
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
            )
          )
        ,),
        
      ]
    );
  }
}