import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class CreateUser extends StatefulWidget{
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  CreateUser({this.auth, this.accentFontColor, this.accentColor, this.fontColor});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=> _CreateUserState();
}

class _CreateUserState extends State<CreateUser>{
  bool isLoading = false;
  bool errorPopped = false;
  String errorMsg = "";
  bool successPopped = false;
  String successMsg = "";
  bool obscureText = true;
  Icon visibilityIcon = new Icon(Icons.visibility);
  void toggleVisibility(){
    setState(() {
      if(obscureText){
        visibilityIcon = new Icon(Icons.visibility);
        obscureText =false;
      }else{
        visibilityIcon = new Icon(Icons.visibility_off);
        obscureText = true;
      }
    });
  }
  final _formKey = new GlobalKey<FormState>();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  String userTypeInput = "Please select from options below";
  int userTypeValue = -1;
  List<Widget> children =[];
  @override
  Widget build(BuildContext context) {
  List<Widget> children = [
    showTitleBar(context),
    showSuccessMessage(context),
    showErrorMessage(context),
    showEmailField(context),
    showUserTypePicker(context),
    showAdminField(context),
    showSubmitButton(context)
  ];
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          new Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: widget.accentColor,
              body: new ListView(
                children: children
              ),
            ),
            ),
          showLoading(context),
        ],
      )
    );
  }

  Visibility showLoading(BuildContext context){
    return Visibility(
      visible: isLoading,
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
  Container showTitleBar(BuildContext context){
    return Container(
      color: widget.accentColor,
      child: new ListTile(
        title: new Text("Create new user",
        style: new TextStyle(
          color: widget.accentFontColor
        )),
      ),
    );
  }
  Container showSuccessMessage(BuildContext context){
    return Container(
      color: Colors.greenAccent,
      child: new Visibility(
        visible: successPopped,
        child: new ListTile(
          title: new Text(successMsg),
          trailing: new IconButton(
            icon: Icon(Icons.highlight_off),
            onPressed:()=> setState(() {
              successPopped = false;
              successMsg = "";
            }),
          )
        ),
      ),
    );
  }

  Container showErrorMessage(BuildContext context){
    return Container(
      color: Colors.red,
      child: new Visibility(
        visible: errorPopped,
        child: new ListTile(
          title: new Text(errorMsg),
          trailing: new IconButton(
            icon: Icon(Icons.highlight_off),
            onPressed:()=> setState(() {
              errorPopped = false;
              errorMsg = "";
            }),
          )
        ),
      ),
    );
  }

  ListTile showEmailField(BuildContext context){
    return CommonWidgets.commonTextFormField(Icons.email, "E-Mail", emailController,widget.fontColor, widget.accentFontColor);
  }

  ListTile showAdminField(BuildContext context){
    return CommonWidgets.commonPasswordFormField(Icons.lock, "Password", passwordController,obscureText,visibilityIcon,widget.fontColor, widget.accentFontColor, toggleVisibility);
  }

  ChoiceChip showChoiceChip(BuildContext context, String roleName, int roleValue){
    return new ChoiceChip(
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(25)),
      label: new Text(roleName,
      style:TextStyle(color: widget.fontColor)),
      selected: userTypeValue == roleValue,
      backgroundColor: widget.accentColor,
      selectedColor: widget.accentFontColor,
      onSelected:(selected){
        setState(() {
          userTypeInput = roleName;
          userTypeValue = roleValue;
          print(roleName + " selected, value is " + roleValue.toString());
        });
      }
    );
  }

  ExpansionTile showUserTypePicker(BuildContext context){
    return new ExpansionTile(
      initiallyExpanded: true,
      leading: new Icon(
        Icons.portrait,
        color: widget.accentFontColor,
      ),
      title: new Text(userTypeInput,style: TextStyle(color: widget.fontColor),),
      children: <Widget>[
        new Wrap(
          spacing:15,
          runAlignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
          showChoiceChip(context, "Contractor", 1),
          showChoiceChip(context, "Production", 2),
          showChoiceChip(context, "Delivery", 3),
          showChoiceChip(context, "Admin", 99),
        ],)
        
      ],
    );
  }
  //Create user logic, Attempts to sign in using provided password by user, if wrong, ends creation process, otherwise will then
  //create a user, log out of the new user as firebase will log in new accounts upon creation, then log into admin account again
  //using provided passwords and email from currentUser method. This way, the password entry will act as a "Pin" so as to not allow
  //Unauthorized user creations.
  void validateAndSubmit() async{
    ValidationMessage result = validateAndSave();
    
    if(result.pass){
      setState(() {
        isLoading = true;
      });
      try{
        return widget.auth.getCurrentUser().then((UserProfile a){
          return widget.auth.signIn(a.fbUser.email, passwordController.text).then((b){
            return widget.auth.signUp(emailController.text, "123456", passwordController.text, userTypeValue).then((x){
              return setState(() {
                isLoading = false;
                errorPopped = false;
                errorMsg = "";
                successPopped = result.pass;
                successMsg = result.message;
                _formKey.currentState.reset();
                passwordController.clear();
                emailController.clear();
                userTypeValue = -1;
                userTypeInput = "Please select from options below";

              });
            }).catchError((e){
              setState((){
                successPopped = false;
                successMsg = "";
                errorPopped = true;
                errorMsg = "User already exists!";
                print(e.message);
                isLoading = false;
              });
            });
          }).catchError((e){
            setState((){
              successPopped = false;
              successMsg = "";
              errorPopped = true;
              errorMsg = "Your password is wrong!";
              print(e.message);
              isLoading = false;
            });
          });
        });
        
      }catch(e){
        setState(() {
          isLoading = false;
          _formKey.currentState.reset();
          passwordController.clear();
          emailController.clear();
          userTypeValue = -1;
          userTypeInput = "Please select from options below";
          successPopped = false;
          successMsg = "";
          errorMsg = e.message;
          errorPopped = true;
        });
      }
    }else{
      setState(() {
        isLoading = false;
        _formKey.currentState.reset();
        passwordController.clear();
        emailController.clear();
        userTypeValue = -1;
        userTypeInput = "Please select from options below";
        successPopped = false;
        successMsg = "";
        errorPopped = true;
        errorMsg =  result.message;
      });
    }
  }

  ValidationMessage validateAndSave(){
    if(passwordController.text == null || passwordController.text.isEmpty){
      return new ValidationMessage(false, message: "Please put in your password!");
    }else if(userTypeValue == -1){
       return new ValidationMessage(false,message: "Please select user type!");
    }else if(!EmailValidator.validate(emailController.text)){
      return new ValidationMessage(false, message: "Email is badly formatted");
    }else{
      return new ValidationMessage(true, message: "User: " + emailController.text.split('@')[0] + " successfully created!");
    }
  }

  Padding showSubmitButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        child: new Text("Submit"),
        gradient: Gradients.hersheys,
        increaseWidthBy: double.infinity,
        callback: ()=> validateAndSubmit(),
      ),
    );
  }
}

class ValidationMessage{
  ValidationMessage(this.pass,{ this.message});
  
  bool pass;
  String message;
}