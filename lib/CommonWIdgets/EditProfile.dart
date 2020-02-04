import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/AdminPages/createUser.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class EditProfile extends StatefulWidget{
  const EditProfile({Key key, this.accentFontColor, this.accentColor, this.fontColor, this.logoutCallback, this.auth});
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;
  
  @override
  State<StatefulWidget> createState()=> EditProfileState();

}

class EditProfileState extends State<EditProfile>{
  bool isLoading = false;
  bool successPopped = false;
  String successMsg = "";
  bool errorPopped = false;
  String errorMsg =  "";
  String newName = "";
  String currentPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";
  TextEditingController nameController = new TextEditingController();
  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

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

  @override
  void initState() {
    nameController.addListener((){
      setState(() {
      newName = nameController.text;
      });
    });
    currentPasswordController.addListener((){
      setState(() {
      currentPassword = currentPasswordController.text;
      });
    });
    passwordController.addListener((){
      setState(() {
      newPassword = passwordController.text;
      });
    });
    confirmPasswordController.addListener((){
      setState(() {
      confirmNewPassword = confirmPasswordController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    currentPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: widget.auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
        if(user.hasData){
          return new Stack(
            children: <Widget>[
              Scaffold(
                appBar: new AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: new IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.accentFontColor,
                    ),
                    onPressed: ()=> Navigator.pop(context),
                  ),
                  title: new Text(
                    "Editing profile...",
                    style: new TextStyle(
                      color: widget.accentFontColor,
                    ),
                  ),
                ),
                body: new ListView(
                  children: <Widget>[
                    showSuccessMessage(context),
                    showErrorMessage(context),
                    showNameEditor(context,user.data.fsUser.data['Name']),
                    showPasswordEditor(context),
                    showConfirmChanges(context, user.data),
                    showLogout(context)
                  ],
                ),
              ),
              bgLoader(context),
            ],
          );
        }else{
          return CommonWidgets.pageLoadingScreen(context);
        }
    });
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

  ExpansionTile showNameEditor(BuildContext context, String name){
    return new ExpansionTile(
      leading: new Icon(Icons.person,
      color: widget.accentFontColor),
      title: new Text("Your name is: " + name + ". Change?",
      style: new TextStyle(
        color: widget.accentFontColor
      ),),
      children: <Widget>[
        showNewNameField(context),
      ],
    );
  }
  
  ListTile showNewNameField(BuildContext context){
    return new ListTile(
      leading: new Icon(
        Icons.person_pin,
        color: widget.accentFontColor,
      ),
      title: new TextFormField(
        controller: nameController,
        decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.accentColor, width: 2.0)),
          hintText: "Your new name"
        ),
        validator: (value){
          if(value == null|| value.isEmpty){
            return "New name is empty!";
          }else{
            return value;
          }
        },
      ),
    );
  }

  ExpansionTile showPasswordEditor(BuildContext context){
    return new ExpansionTile(
      leading: new Icon(Icons.lock_outline,
      color: widget.accentFontColor),
      title: new Text("Change your password?",
      style: new TextStyle(
        color: widget.accentFontColor
      ),),
      children: <Widget>[
        showCurrentPasswordField(context),
        showNewPasswordField(context),
        confirmNewPasswordField(context),
      ],
    );
  }
  ListTile showCurrentPasswordField(BuildContext context){
    return new ListTile(
      leading: new Icon(
        Icons.lock,
        color: widget.accentFontColor,
      ),
      title: new TextFormField(
        obscureText: !visible,
        controller: currentPasswordController,
        decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.accentColor, width: 2.0)),
          hintText: "Current Password"
        ),
        validator: (value){
          if(value == null|| value.isEmpty){
            return "Current password is empty!";
          }else{
            return value;
          }
        },
      ),
      trailing: new IconButton(
        icon: visibilityIcon,
        onPressed: ()=>toggleVisibility(),
      ),
    );
  }
  ListTile showNewPasswordField(BuildContext context){
    return new ListTile(
      leading: new Icon(
        Icons.lock,
        color: widget.accentFontColor,
      ),
      title: new TextFormField(
        obscureText: !visible,
        controller: passwordController,
        decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.accentColor, width: 2.0)),
          hintText: "New Password"
        ),
        validator: (value){
          if(value == null|| value.isEmpty){
            return "New name is empty!";
          }else{
            return value;
          }
        },
      ),
    );
  }
   
  ListTile confirmNewPasswordField(BuildContext context){
    return new ListTile(
      leading: new Icon(
        Icons.lock,
        color: widget.accentFontColor,
      ),
      title: new TextFormField(
        obscureText: !visible,
        autovalidate: true,
        controller: confirmPasswordController,
        decoration: new InputDecoration(
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: widget.accentColor, width: 2.0)),
          hintText: "Confirm new password"
        ),
        validator: (value){
          if(value == null|| value.isEmpty){
            return "Confirm new password is empty!";
          }else if(newPassword != confirmNewPassword){
            return "New password and confirm new password must be the same!";
          }else{
          }
        },
      ),
    );
  }

  bool submittable = true;
  Padding showConfirmChanges(BuildContext context, UserProfile user){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        isEnabled: submittable,
        child: new Text("Submit"),
        gradient: Gradients.taitanum,
        increaseWidthBy: double.infinity,
        callback: ()=> validateAndSubmit(user.fsUser.documentID, user)
      ),
    );
  }

  
  Padding showLogout(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        child: new Text("Logout"),
        gradient: Gradients.blush,
        increaseWidthBy: double.infinity,
        callback: ()=> showDialog(
              context: context,
              child: CommonWidgets.logoutDialog(context, widget.logoutCallback,true),
        ).then((x){
          Navigator.pop(context);
          }
        ),
      )
    );
  }

  void validateAndSubmit(String email, UserProfile user) async{
    
    if(newName.isNotEmpty && currentPassword.isEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty){
      setState(() {
        isLoading = true;
      });
      try{
        Firestore.instance.collection("Users").document(email).setData({'Name': newName}, merge: true).then((x){
          setState(() {
            isLoading = false;
            successPopped = true;
            successMsg = "Name has been successfully changed.";
            nameController.clear();
            errorMsg = "";
            errorPopped = false;
          });
        });
      }catch(e){
        setState(() {
          isLoading = false;
          successPopped = false;
          successMsg = "";
          errorMsg = e.message;
          errorPopped = true;
        });
      }
    }else if(newName.isEmpty && currentPassword.isNotEmpty && newPassword.isNotEmpty && confirmNewPassword.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      widget.auth.signIn(email, currentPassword).then((UserProfile log){
        user.fbUser.updatePassword(newPassword).then((x){
          setState(() {
            isLoading = false;
            successPopped = true;
            currentPasswordController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            successMsg = "Password has been successfully changed.";
            errorMsg = "";
            errorPopped = false;
          });
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
      
    }else if(newName.isNotEmpty && currentPassword.isNotEmpty && newPassword.isNotEmpty && confirmNewPassword.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      widget.auth.signIn(email, currentPassword).then((UserProfile log){
        user.fbUser.updatePassword(newPassword).then((x){
          Firestore.instance.collection("Users").document(email).setData({'Name': newName}, merge: true).then((x){
            setState(() {
              isLoading = false;
              successPopped = true;
              successMsg = "Name and Password has been successfully changed.";
              errorMsg = "";
              errorPopped = false;
              nameController.clear();
              currentPasswordController.clear();
              passwordController.clear();
              confirmPasswordController.clear();
            });
          });
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
    }else if(newName.isEmpty && currentPassword.isEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty){
      setState(() {
        isLoading = false;
        successPopped = false;
        successMsg = "";
        errorMsg = "Please check the fields";
        errorPopped = true;
      });
    }else{
      setState(() {
        isLoading = false;
        successPopped = false;
        successMsg = "";
        errorMsg = "Please check the fields";
        errorPopped = true;
      });
    }
  }

  ValidationMessage validateAndSave(){
    if(newName.isEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty){
        return new ValidationMessage(false, message: "Please check the fields");
    }else{
      if(newName.isNotEmpty && newPassword.isEmpty && confirmNewPassword.isEmpty){
        return new ValidationMessage(true, message: "User: " + " successfully updated!");
      }else if(newName.isEmpty && newPassword.isNotEmpty && confirmNewPassword.isNotEmpty){
        
        return new ValidationMessage(true, message: "User: " + " successfully updated!");
      }else{
        
        return new ValidationMessage(false, message: "Please check the fields");
      }
    }
  }
}