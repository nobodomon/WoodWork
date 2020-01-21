import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'Authentication/Authentication.dart';
import 'Authentication/UserProfile.dart';

class Login extends StatefulWidget{
  Login({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login>{
  String errorMsg = "";
  String _email;
  String _password;
  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  bool errorPopped = false;
  final emailController = TextEditingController();
  final passwordController = new TextEditingController();
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
  bool validateAndSave(){
    _email = emailController.text;
    _password = passwordController.text;
    if(_email != null && _password != null){
      return true;
    }else{
      return false;
    }
  }
  void validateAndSubmit() async {
    setState(() {
      errorMsg = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      UserProfile user;
      try {
        user = await widget.auth.signIn(_email, _password);
        print('Signed in: $_email');
      
        setState(() {
          _isLoading = false;
        });

        if (user.fbUser.uid.length > 0 && user.fbUser.uid.length != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');

        setState(() {
          _isLoading = false;
          errorMsg = e.message;
          if(e.message == "There is no user record corresponding to this identifier. The user may have been deleted."){
            errorMsg = "Email or password is incorrect. Please try again.";
          }else if(e.message == "The password is invalid or the user does not have a password."){
            errorMsg = "Email or password is incorrect. Please try again.";
          }
          
          errorPopped = true;
          _formKey.currentState.reset();
        });
      }
    }
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
                Container(
                  color:Colors.blueGrey[700],
                  child: ListTile(
                    leading: new GradientText(
                      "Login",
                      gradient: Gradients.coralCandyGradient,
                      style: new TextStyle(
                        fontSize: 21,
                        color: Theme.of(context).primaryTextTheme.title.color
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                new Form(
                  key: _formKey,
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
                          controller: passwordController,
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
                        child: Container(
                          color: Colors.red[500],
                          child: new ListTile(
                            enabled: errorPopped,
                            title: new Text(
                              errorMsg,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.black
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
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new GradientButton(
                          child: new Text("Submit"),
                          increaseWidthBy: double.infinity,
                          callback: (){
                            validateAndSubmit();
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
        showLoading(context)
        ],
      ),
    );
  }

  Visibility showLoading(BuildContext context){
    return Visibility(
      visible: _isLoading,
        child: new Scaffold(
          backgroundColor:Colors.black54,
          body: Center(
            child: new Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              width: 175,
              height: 175,
              child: new CircularProgressIndicator(),
            ),
          )
        ),
    );
  }
}