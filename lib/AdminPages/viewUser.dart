import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ViewUser extends StatefulWidget{
  ViewUser({this.email, this.userType, this.accentFontColor, this.accentColor, this.fontColor});
  final Color accentFontColor;
  final Color accentColor;
  final Color fontColor;

  @override
  State<StatefulWidget> createState()=> new ViewUserState();
  final String email;
  final int userType;
}

class ViewUserState extends State<ViewUser>{
  String userTypeInput = "Please select an option from below.";
  int userTypeValue = -1;
  bool isLoading = false;
  bool successPopped = false;
  String successMsg = "";
  bool errorPopped = false;
  String errorMsg = "";
  Color fontColor = Colors.black;
  Color iconColor = Colors.blueGrey[700];
  void dismissError(){
    setState(() {
      errorPopped = false;
      errorMsg = "";
    });
  }

  
  void dismissSuccess(){
    setState(() {
      successPopped = false;
      successMsg = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().getUserByEmail(widget.email),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
        if(user.hasData){
          return Scaffold(
          backgroundColor: widget.accentColor,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: widget.accentFontColor,),
              onPressed: ()=>Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              "Editing " + user.data.fsUser.data['Name'] + "'s Profile...", 
              style: new TextStyle(color: widget.accentFontColor,)
            ),
          ),
          body: Stack(
            children: <Widget>[
            new ListView(
              children: <Widget>[
                showErrorMessage(context),
                showSuccessMessage(context),
                showDeleteOrEnableButtons(context, user.data),
                showEmail(context,user.data),
                showLastLogin(context, user.data),
                showUserRoleSelector(context, user.data.fsUser.data['Usertype']),
                showConfirmChanges(context, user.data),
              ],
            ),
            showLoading(context),
            ],
          )
         );
        }else{
          return Scaffold(
            backgroundColor: Colors.black87,
            body: new Center(
              child: new CircularProgressIndicator(),
            )
          );
        }
      }
    );
  }
  

  Visibility showLoading(BuildContext context){
    return Visibility(
      visible: isLoading,
        child: new Scaffold(
          backgroundColor:Colors.black38,
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
  
  Container showSuccessMessage(BuildContext context){
    return CommonWidgets.commonSuccessMessage(context, successPopped, successMsg, dismissSuccess);
  }
  
  Container showErrorMessage(BuildContext context){
    return CommonWidgets.commonErrorMessage(context, errorPopped, errorMsg, dismissError);
  }

  Widget showDeleteOrEnableButtons(BuildContext context, UserProfile user){
    if(user.fsUser.data['Usertype'] == -1){
      return showReEnableUser(context, user);
    }else{
      return showDeleteUser(context, user);
    }
  }

  Widget showDeleteUser(BuildContext context, UserProfile user){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        child: new Text("Delete User"),
        gradient: Gradients.serve,
        increaseWidthBy: double.infinity,
        callback: ()=> new Auth().deleteUser(context, user).then((DeleteResult result){
          if(result == null){

          }else{
            setState(() {
            successPopped = true;
            successMsg = "User successfully deleted.";
          });
          }
        }),
      ),
    );
  }

  Widget showReEnableUser(BuildContext context, UserProfile user){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        child: new Text("Re-enable User"),
        gradient: Gradients.coldLinear,
        increaseWidthBy: double.infinity,
        callback: ()=> new Auth().renableUser(context, user).then((DeleteResult result){
          
          if(result == null){

          }else{
            setState(() {
            successPopped = true;
            successMsg = "User successfully re-enabled.";
          });
          }
        }),
      ),
    );
  }

  Widget showEmail(BuildContext context, UserProfile user){
    String email = user.fsUser.documentID;
    return new ListTile(
      leading: new Icon(Icons.email,
        color: widget.accentFontColor,
      ),
      title: new Text("E-mail:",
        style: new TextStyle(
          color: widget.fontColor,
        ),
      ),
      subtitle: new Text(email,
        style: new TextStyle(
          color: widget.fontColor,
        ),
      ),
    );
  }

  Widget showLastLogin(BuildContext context, UserProfile user){
    String timestamp = user.fsUser.data['Last-login'].toString();
    if(timestamp == "null" || timestamp.isEmpty){
      timestamp = "has not logged in yet.";
    }
    return new ListTile(
      leading: new Icon(Icons.timeline,
        color: widget.accentFontColor,
      ),
      title: new Text("Last logged in:",
        style: new TextStyle(
          color: widget.fontColor,
        ),
      ),
      subtitle: new Text(timestamp,
        style: new TextStyle(
          color: widget.fontColor,
        ),
        ),
    );
  }

  ChoiceChip showChoiceChip(BuildContext context, String roleName, int roleValue){
    return new ChoiceChip(
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(25)),
      label: new Text(roleName,
      style:TextStyle(color: widget.fontColor)),
      selected: userTypeValue == roleValue,
      backgroundColor: widget.accentColor,
      selectedColor: widget.accentFontColor,
      onSelected:(bool selected){
        setState(() {
          userTypeInput = roleName  + " role selected";
          userTypeValue = roleValue;
          mapRoleToColor(roleValue);
          print(roleName + " selected, value is " + roleValue.toString());
        });
      }
    );
  }
  Widget populateWidgets(){
    return new FutureBuilder(
      future: Auth().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> admin){
        if(admin.hasData){
          List<Widget> list = [];
          list.add(showChoiceChip(context, "Contractor", 1));
          list.add(showChoiceChip(context, "Production", 2));
          list.add(showChoiceChip(context, "Delivery", 3));
          if(admin.data.fsUser.data['Usertype'] == 999){
            list.add(showChoiceChip(context, "Admin", 99));
          }else{

          }
          return new Wrap(
            spacing: 15,
            runAlignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: list,
          );
        }else{
          return LinearProgressIndicator(
            backgroundColor: Colors.blueGrey[700],
          );
        }
      },
    );
  }

  Color userColor;

  void mapRoleToColor(int currUserType){
    setState(() {
      switch (currUserType) {
        case 1:
          userColor = Colors.yellow[400];
          break;
        case 2:
          userColor = Colors.red[400];
          break;
        case 3:
          userColor = Colors.blue[400];
          break;
        case 99:
          userColor = Colors.green[400];
          break;
        case 999:
          userColor = Colors.teal[400];
          break;
        case -1:
          userColor = widget.fontColor;
          break;
      }
    });
  }

  Widget showUserRoleSelector(BuildContext context, int currUserType){
    
    Color userColor;
      switch (currUserType) {
        case 1:
          userColor = Colors.yellow[400];
          break;
        case 2:
          userColor = Colors.red[400];
          break;
        case 3:
          userColor = Colors.blue[400];
          break;
        case 99:
          userColor = Colors.green[400];
          break;
        case 999:
          userColor = Colors.teal[400];
          break;
        case -1:
          userColor = widget.fontColor;
          break;
      }
    // userTypeInput = "User current role is " + CommonWidgets.mapUserRoleToLongName(currUserType);
    bool expanded;
    if(currUserType == -1){
      expanded = false;
      return new ListTile(
        leading: new Icon(
          Icons.portrait,
          color: widget.accentFontColor,
        ),
        title: new RichText(
          text: TextSpan(
            text:"Current user type is: ",
            style: new TextStyle(
              color: widget.fontColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: CommonWidgets.mapUserRoleToLongName(currUserType),
                style: new TextStyle(
                  color: userColor
                )
              )
            ]
          )
        ),
      );
    }else{
      expanded = true;
      return new ExpansionTile(
        initiallyExpanded: expanded,
        onExpansionChanged: ((value){
          setState(() {
            
          });
        }),
        leading: new Icon(
          Icons.portrait,
          color: widget.accentFontColor,
        ),
        title: new RichText(
          text: TextSpan(
            text:"Current user type is: ",
            style: new TextStyle(
              color: widget.fontColor,
            ),
            children: <TextSpan>[
              TextSpan(
                text: CommonWidgets.mapUserRoleToLongName(currUserType),
                style: new TextStyle(
                  color: userColor
                )
              )
            ]
          )
        ),
        children: <Widget>[
          new ListTile(
            title: new Text(userTypeInput,
              style: new TextStyle(
                color: widget.fontColor,
              ),
            ),
            leading: new Icon(
              Icons.chevron_right,
              color: widget.accentFontColor,
            ),
          ),
          populateWidgets()
        ],
      );
    }
  }

  void validateAndSubmit(String email) async{
    ValidationMessage result = validateAndSave();
    
    if(result.pass){
      setState(() {
        isLoading = true;
      });
      try{
        Firestore.instance.collection("Users").document(email).setData({'Usertype': userTypeValue}, merge: true).then((x){
          setState(() {
            isLoading = false;
            userTypeValue = -1;
            userTypeInput = "Please select from options below";
            successPopped = true;
            successMsg = "User has been successfully updated.";
            errorMsg = "";
            errorPopped = false;
          });
        });
      }catch(e){
        setState(() {
          isLoading = false;
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
    if(userTypeValue == -1){
       return new ValidationMessage(false,message: "Please select user type!");
    }else{
      return new ValidationMessage(true, message: "User: " + " successfully created!");
    }
  }

  Padding showConfirmChanges(BuildContext context, UserProfile user){
    bool enabled;
    if(user.fsUser.data['Usertype'] == -1){
      enabled = false;
    }else{
      enabled = true;
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        isEnabled: enabled,
        child: new Text("Submit"),
        gradient: CommonWidgets.subGradient,
        increaseWidthBy: double.infinity,
        callback: ()=> validateAndSubmit(user.fsUser.documentID)
      ),
    );
  }
}


class ValidationMessage{
  ValidationMessage(this.pass,{ this.message});
  
  bool pass;
  String message;
}