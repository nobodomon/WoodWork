import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/Authentication/Authentication.dart';

import 'CommonWIdgets/commonWidgets.dart';

class ForgetPassword extends StatefulWidget{
  const ForgetPassword({Key key, this.auth, this.accentFontColor, this.accentColor, this.fontColor});
  final Auth auth;
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;

  @override
  State<StatefulWidget> createState()=> ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword>{
  
  TextEditingController emailController = new TextEditingController();
  String email = "";
  bool isLoading = false;
  bool successPopped = false;
  String successMsg = "";
  bool errorPopped = false;
  String errorMsg =  "";
  @override
  void initState() {
    emailController.addListener((){
      setState(() {
      email = emailController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Scaffold(
          backgroundColor: widget.accentColor,
          appBar: new AppBar(
            title: new Text("Forget password?", style: new TextStyle(color: widget.accentFontColor)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: new IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: widget.accentFontColor,
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ),
          body: ListView(
            children: <Widget>[
              showSuccessMessage(context),
              showErrorMessage(context),
              showEmailEditor(context),
              showConfirmChanges(context),
            ]
          ),
        ),
        bgLoader(context),
      ],
    );
  }

  Widget bgLoader(BuildContext context){
    return Visibility(
      visible: isLoading,
      child: CommonWidgets.pageLoadingScreen(context),
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

  ExpansionTile showEmailEditor(BuildContext context){
    return new ExpansionTile(
      initiallyExpanded: true,
      leading: new Icon(Icons.person,
      color: widget.accentFontColor),
      title: new Text("Put in your email tied to your account.",
      style: new TextStyle(
        color: widget.fontColor
      ),),
      children: <Widget>[
        showNewEmailField(context),
      ],
    );
  }
  
  ListTile showNewEmailField(BuildContext context){
    return CommonWidgets.commonTextFormField(Icons.email, "Email...", emailController, widget.fontColor, widget.accentFontColor);
  }
  
  Padding showConfirmChanges(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        child: new Text("Submit"),
        gradient: Gradients.backToFuture,
        increaseWidthBy: double.infinity,
        callback: ()=> validateAndSubmit(email)
      ),
    );
  }

  void validateAndSubmit(String email){
    setState(() {
      isLoading = true;
    });
    EmailCheckResult result = validateAndSave(email);
    if(result.pass){
        FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((x){
          setState(() {
            isLoading = false;
            successPopped = true;
            successMsg = "Password reset link successfully sent to the email.";
            errorMsg = "";
            errorPopped = false;
            emailController.clear();
          });
        }).catchError((e){
          
          setState(() {
            isLoading = false;
            successPopped = false;
            successMsg = "";
            errorMsg = e.toString();
            errorPopped = true;
          });
        });
    }else{
      setState(() {
        isLoading = false;
        successPopped = false;
        successMsg = "";
        errorMsg = result.remark;
        errorPopped = true;
      });
    }
  }

  EmailCheckResult validateAndSave(String email){
    if(EmailValidator.validate(email)){
      return new EmailCheckResult(true, "Email is malformed!");
    }else{
      return new EmailCheckResult(false, "Email is malformed!");
    }
  }
}

class EmailCheckResult{
  final bool pass;
  final String remark;

  EmailCheckResult(this.pass, this.remark);
}