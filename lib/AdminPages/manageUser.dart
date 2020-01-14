import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/Authentication/Authentication.dart';

class ManageUser extends StatefulWidget{
  ManageUser({this.auth});
  Auth auth;
  @override
  State<StatefulWidget> createState() => new _ManageUserState();
}

class _ManageUserState extends State<ManageUser>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
      stream: widget.auth.getAllUsers().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> users){
        if(users.hasData && users.data.documents.length>0){
          return new Scaffold(
            body: new ListView.builder(
              itemCount: users.data.documents.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: new SizedBox(
                    width: 15,
                    height: 15,
                    child: new Text(users.data.documents[index].data['Usertype'].toString()),
                  ),
                  title: new Text(users.data.documents[index].data['Name']),
                  subtitle: new Text(users.data.documents[index].data['Usertype'].toString()),
                );
              },
            ),
          );
        }else{
          return new Scaffold(
            body: new Center(
              child: new CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}