import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login>{
  
  Alignment childAlignment = Alignment.center;
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
    onChange: (bool visible) {
      // Add state updating code
      setState(() {
        childAlignment = visible ? Alignment.topCenter : Alignment.center;
      });
    },
  );
  super.initState();
  }
  bool visible = false;
  Icon visibilityIcon = new Icon(Icons.visibility_off);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "WoodWork", 
          style: new TextStyle(
            color: Theme.of(context).primaryTextTheme.title.color),
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: new Stack(
        children: <Widget>[
        new Image.asset(
              'assets/images/WoodGrain.jpeg',
              fit: BoxFit.cover,
            ),
        new AnimatedContainer(
          curve: Curves.easeOut,
          duration: Duration(
            milliseconds: 400,
          ),
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          alignment: childAlignment,
          child: new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            margin: new EdgeInsets.all(50),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(15),
                  child: new Text(
                    "Login",
                    style: new TextStyle(
                      fontSize: 21,
                      color: Theme.of(context).primaryTextTheme.title.color
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                new Divider(),
                new ListTile(
                  leading: new Icon(Icons.email),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                      hintText: "E-Mail"
                    ),
                  )),
                new ListTile(
                  leading: new Icon(Icons.lock),
                  title: new TextFormField(
                    decoration: new InputDecoration(
                      hintText: "Password"
                      
                    ),
                    obscureText: !visible,
                  ),
                  trailing: new IconButton(
                    icon: visibilityIcon,
                    onPressed: ()=>toggleVisibility(),
                  )),
                new RaisedButton(child: new Text("Submit"),onPressed: ()=> null,)
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}