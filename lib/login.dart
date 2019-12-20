import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:woodwork/AdminPages/adminHome.dart';
import 'package:woodwork/ContractorPages/contractorHome.dart';
import 'package:woodwork/ProductionPages/productionHome.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login>{
  String errorMsg = "";
  bool errorPopped = false;
  final emailController = TextEditingController();
  Alignment childAlignment = Alignment.center;
  double topPadding = 20;
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
    onChange: (bool visible) {
      // Add state updating code
      setState(() {
        childAlignment = visible ? Alignment.topCenter : Alignment.center;
        topPadding = visible ? 150 : 20;
      });
    },
  );
  super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  bool visible = false;
  Icon visibilityIcon = new Icon(Icons.visibility);
  void toggleVisibility(){
    setState(() {
      if(visible){
        visibilityIcon = new Icon(Icons.visibility);
        visible =false;
      }else{
        visibilityIcon = new Icon(Icons.visibility_off);
        visible = true;
      }
    });
  }
  String emailInput;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /* appBar: new AppBar(
        title: new GradientText(
          "WoodWork", 
          gradient: Gradients.taitanum,
          style: new TextStyle(
            color: Theme.of(context).primaryTextTheme.title.color),
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ), */
      body: new Stack(
        children: <Widget>[
        new Image.asset(
              'assets/images/WoodGrain.jpeg',
              height: 400,
              fit: BoxFit.fill
            ),
        new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: new GradientText(
              "WoodWork",
              gradient: Gradients.taitanum,
              style: new TextStyle(
                color: Theme.of(context).primaryTextTheme.title.color),
              ),
            ),
          ),       
        new AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(
            milliseconds: 300,
          ),
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(20,topPadding,20,20),
          alignment: childAlignment,
          child: new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            margin: new EdgeInsets.all(12.5),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(15),
                  child: new GradientText(
                    "Login",
                    gradient: Gradients.taitanum,
                    style: new TextStyle(
                      fontSize: 21,
                      color: Theme.of(context).primaryTextTheme.title.color
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                new Divider(),
                new Form(
                  child:Column(
                    children: <Widget>[
                      new ListTile(
                        leading: new Icon(
                          Icons.email,
                          color: Colors.blueGrey[600],
                        ),
                        title: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: new InputDecoration(
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[600], width: 2.0)),
                            hintText: "E-Mail"
                          ),
                        )),
                      new ListTile(
                        leading: new Icon(
                          Icons.lock,
                          color: Colors.blueGrey[600],
                        ),
                        title: new TextFormField(
                          decoration: new InputDecoration(
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[600], width: 2.0)),
                            hintText: "Password"
                            
                          ),
                          obscureText: !visible,
                        ),
                        trailing: new IconButton(
                          icon: visibilityIcon,
                          onPressed: ()=>toggleVisibility(),
                        )),
                      new Visibility(
                        visible: errorPopped,
                        child: new ListTile(
                          enabled: errorPopped,
                          title: new Text(
                            errorMsg,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.red[500]
                            )),
                          dense: true,
                          trailing: new IconButton(
                            icon: Icon(Icons.highlight_off),
                            onPressed: ()=>setState(() {
                              errorMsg = "";
                              errorPopped = false;
                            }),
                          ),
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new GradientButton(
                          child: new Text("Submit"),
                          increaseWidthBy: double.infinity,
                          callback: (){

                            switch(emailController.text){
                              case "Admin": {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AdminHome()),
                                );
                              }break;
                              case "Contractor": {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ContractorHome()),
                                );
                              }break;
                              case "Production": {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductionHome()),
                                );
                              }break;
                              case "Delivery": {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ContractorHome()),
                                );
                              }break;
                              default: {
                                setState((){
                                  errorMsg = "Invalid Email!";
                                  errorPopped = true;
                                });
                              }
                            }
                          },
                          gradient: Gradients.taitanum,),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}