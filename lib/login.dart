import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:woodwork/ForgetPassword.dart';
import 'Authentication/Authentication.dart';
import 'Authentication/UserProfile.dart';
import 'CommonWIdgets/commonWidgets.dart';

class Login extends StatefulWidget {
  Login(
      {this.auth,
      this.loginCallback,
      this.accentFontColor,
      this.accentColor,
      this.fontColor});

  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  String errorMsg = "";
  String _email;
  String _password;
  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  bool errorPopped = false;
  final emailController = TextEditingController();
  final passwordController = new TextEditingController();
  Alignment childAlignment = Alignment.center;
  double topPadding = 350;
  double height = 250;
  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        // Add state updating code
        setState(() {
          //childAlignment = visible ? Alignment.topCenter : Alignment.center;
          height = visible ? 150 : 250;
          topPadding = visible ? 150 : 350;
        });
      },
    );
    super.initState();
  }

  bool visible = false;
  Icon visibilityIcon = new Icon(Icons.visibility);
  void toggleVisibility() {
    setState(() {
      if (visible) {
        visibilityIcon = new Icon(Icons.visibility);
        visible = false;
      } else {
        visibilityIcon = new Icon(Icons.visibility_off);
        visible = true;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    _email = emailController.text;
    _password = passwordController.text;
    if (_email != null && _password != null) {
      return true;
    } else {
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
          if (e.message ==
              "There is no user record corresponding to this identifier. The user may have been deleted.") {
            errorMsg = "Email or password is incorrect. Please try again.";
          } else if (e.message ==
              "The password is invalid or the user does not have a password.") {
            errorMsg = "Email or password is incorrect. Please try again.";
          }

          errorPopped = true;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void dismissError(){
    setState(() {
      errorPopped = false;
      errorMsg = "";
    });
  }

  
  void dismissSuccess(){
    setState(() {
      errorPopped = false;
      errorMsg = "";
    });
  }

  String emailInput;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            height: double.maxFinite,
            decoration: new BoxDecoration(gradient: CommonWidgets.mainGradient),
          ),
          new Scaffold(
            backgroundColor: Colors.transparent,
            body: new AnimatedContainer(
            curve: Curves.easeInOut,
              duration: Duration(
                milliseconds:300
              ),
              decoration: BoxDecoration(
                gradient:CommonWidgets.subGradient,
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(100))
              ),
              height: height,
              child: new Center(
                child: new Text(
                  "WoodWork",
                  style: new TextStyle(
                      fontStyle: FontStyle.italic,
                      color: widget.fontColor,
                      fontSize: 42),
                ),
              ),
            ),
          ),
          new AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(
              milliseconds: 300,
            ),
            padding: EdgeInsets.fromLTRB(20, topPadding, 20, 20),
            alignment: Alignment.topCenter,
            child: new Card(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              margin: new EdgeInsets.all(12.5),
              child: SingleChildScrollView(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CommonWidgets.commonErrorMessage(context, errorPopped, errorMsg, dismissError),
                          CommonWidgets.commonTextFormField(
                              Icons.email,
                              "E-Mail",
                              emailController,
                              widget.fontColor,
                              widget.accentFontColor),
                          CommonWidgets.commonPasswordFormField(
                              Icons.lock,
                              "Password",
                              passwordController,
                              visible,
                              visibilityIcon,
                              widget.fontColor,
                              widget.accentFontColor,
                              toggleVisibility),
                          new FlatButton(
                            child: new Text("Forgot password?"),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgetPassword(
                                          fontColor: widget.fontColor,
                                          accentFontColor:
                                              widget.accentFontColor,
                                          accentColor: widget.accentColor,
                                          auth: widget.auth,
                                        ))),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: new GradientButton(
                              child: new Text("Login"),
                              increaseWidthBy: double.infinity,
                              callback: () {
                                validateAndSubmit();
                              },
                              gradient: CommonWidgets.subGradient,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          showLoading(context)
        ],
      ),
    );
  }

  Visibility showLoading(BuildContext context) {
    return Visibility(
      visible: _isLoading,
      child: new Scaffold(
          backgroundColor: Colors.black54,
          body: Center(
            child: new Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              width: 175,
              height: 175,
              child: new CircularProgressIndicator(),
            ),
          )),
    );
  }
}
