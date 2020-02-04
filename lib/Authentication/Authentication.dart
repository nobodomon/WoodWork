import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woodwork/Authentication/UserProfile.dart';
import 'package:woodwork/CommonWIdgets/commonWidgets.dart';

abstract class BaseAuth {
  Future<UserProfile> signIn(String email, String password);

  Future<void> signUp(
      String email, String password, String adminPassword, int userType);

  Future<UserProfile> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserProfile> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    DocumentSnapshot fsUser =
        await Firestore.instance.collection("Users").document(email).get();
    Firestore.instance
        .collection("Users")
        .document(email)
        .setData({'Last-login': DateTime.now()}, merge: true);
    return new UserProfile(fbUser: user, fsUser: fsUser);
  }

  Future<AuthResult> signUp(
      String email, String password, String adminPassword, int userType) async {
    //Usertypes, 99 -> Admin, 999 -> S.Admin, 1 -> Contractor, 2 -> Production, 3 -> Delivery
    return getCurrentUser().then((UserProfile x) {
      return _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((AuthResult y) {
        return Firestore.instance.collection("Users").document(email).setData(
            {'Name': email.split('@')[0], 'Usertype': userType}).then((z) {
          _firebaseAuth.signOut();
          return _firebaseAuth
              .signInWithEmailAndPassword(
                  email: x.fbUser.email, password: adminPassword)
              .then((AuthResult a) {
            return a;
          });
        });
      });
    });
  }

  Future<UserProfile> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user == null) {
      return null;
    }
    DocumentSnapshot fsUser =
        await Firestore.instance.collection("Users").document(user.email).get();
    return new UserProfile(fbUser: user, fsUser: fsUser);
  }

  Future<FirebaseUser> getFireBaseCurrentuser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<DeleteResult> deleteUser(BuildContext context, UserProfile user) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirm delete user?"),
            content: new Text("This will make the user unable to login until account is re-enabled."),
            actions: <Widget>[
              new FlatButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CommonWidgets.pageLoadingScreen(context)));
                    return Firestore.instance
                        .collection("Users")
                        .document(user.fsUser.documentID)
                        .setData({'Usertype': -1, 'WasType': user.fsUser.data['Usertype']}, merge: true).then((x) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          return new DeleteResult(true, "User deleted");
                    });
                  },
                  child: new Text("Confirm")),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Cancel")),
            ],
          );
        });
  }

  Future<DeleteResult> renableUser(BuildContext context, UserProfile user) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirm re-enable user?"),
            content: new Text("This will make the user able to login again."),
            actions: <Widget>[
              new FlatButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CommonWidgets.pageLoadingScreen(context)));
                    return Firestore.instance
                        .collection("Users")
                        .document(user.fsUser.documentID)
                        .setData({'Usertype': user.fsUser.data['WasType']}, merge: true).then((x) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          return new DeleteResult(true, "User re-enabled");
                    });
                  },
                  child: new Text("Confirm")),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Cancel")),
            ],
          );
        });
  }

  Future<UserProfile> getUserByEmail(String email) async {
    DocumentSnapshot fsUser =
        await Firestore.instance.collection("Users").document(email).get();
    return new UserProfile(fbUser: null, fsUser: fsUser);
  }

  Future<DocumentSnapshot> getFSUserByEmail(String email) async {
    DocumentSnapshot fsUser =
        await Firestore.instance.collection("Users").document(email).get();
    return fsUser;
  }

  Future<QuerySnapshot> getAllUsers() async {
    return getCurrentUser().then((UserProfile user) {
      return Firestore.instance
          .collection("Users")
          .getDocuments()
          .then((QuerySnapshot users) {
        switch (user.fsUser.data['Usertype']) {
          case 99:
            users.documents.removeWhere((searchUser) =>
                searchUser.data['Usertype'] == 99 ||
                searchUser.data['Usertype'] == 999);
            break;
          case 999:
            users.documents.removeWhere(
                (searchUser) => searchUser.data['Usertype'] == 999);
            break;
        }
        return users;
      });
    });
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}

class DeleteResult {
  final bool pass;
  final String remarks;

  DeleteResult(this.pass, this.remarks);
}
