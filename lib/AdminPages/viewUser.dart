import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:woodwork/Authentication/Authentication.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

class ViewUser extends StatefulWidget{
  ViewUser({this.email, this.userType});

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().getUserByEmail(widget.email),
      builder: (BuildContext context, AsyncSnapshot<UserProfile> user){
        if(user.hasData){
          return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: iconColor,),
              onPressed: ()=>Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              "Editing " + user.data.fsUser.data['Name'] + "'s Profile...", 
              style: new TextStyle(color: fontColor,)
            ),
          ),
          body: Stack(
            children: <Widget>[
            new ListView(
              children: <Widget>[
                showErrorMessage(context),
                showSuccessMessage(context),
                showLastLogin(context, user.data),
                showUserRoleSelector(context, user.data.fsUser.data['Usertype']),
                showConfirmChanges(context, widget.email),
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

  Widget showLastLogin(BuildContext context, UserProfile user){
    String timestamp = user.fsUser.data['Last-login'].toString();
    if(timestamp == "null" || timestamp.isEmpty){
      timestamp = "has not logged in yet.";
    }
    return new ListTile(
      leading: new Icon(Icons.timeline,
        color: iconColor
      ),
      title: new Text("Last logged in:",
        style: new TextStyle(
          color: fontColor,
        ),
      ),
      subtitle: new Text(timestamp),
    );
  }

  ChoiceChip showChoiceChip(BuildContext context, String roleName, int roleValue){
    Color selectedColor = Colors.blueGrey[300];
    return new ChoiceChip(
      label: new Text(roleName),
      backgroundColor: selectedColor,
      selected: userTypeValue == roleValue,
      selectedColor: Colors.blueGrey[700],
      onSelected:(bool selected){
        setState(() {
          userTypeInput = roleName  + " role selected";
          userTypeValue = roleValue;
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

  Widget showUserRoleSelector(BuildContext context, int currUserType){
    // userTypeInput = "User current role is " + CommonWidgets.mapUserRoleToLongName(currUserType);
    return new ExpansionTile(
      initiallyExpanded: true,
      onExpansionChanged: ((value){
        setState(() {
          
        });
      }),
      leading: new Icon(
        Icons.portrait,
        color: iconColor,
      ),
      title: new Text(
        "Current user type is: " + CommonWidgets.mapUserRoleToLongName(currUserType),
        style: new TextStyle(
          color: fontColor,
        ),
      ),
      children: <Widget>[
        new ListTile(
          title: new Text(userTypeInput,
            style: new TextStyle(
              color: iconColor,
            ),
          ),
          leading: new Icon(
            Icons.chevron_right,
            color: iconColor,
          ),
        ),
        populateWidgets()
      ],
    );
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

  Padding showConfirmChanges(BuildContext context, String email){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: new GradientButton(
        child: new Text("Submit"),
        gradient: Gradients.taitanum,
        increaseWidthBy: double.infinity,
        callback: ()=> validateAndSubmit(email),
      ),
    );
  }
}


class ValidationMessage{
  ValidationMessage(this.pass,{ this.message});
  
  bool pass;
  String message;
}