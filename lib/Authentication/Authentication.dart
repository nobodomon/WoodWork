import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:woodwork/Authentication/UserProfile.dart';

abstract class BaseAuth {
  Future<UserProfile> signIn(String email, String password);

  Future<void> signUp(String email, String password, String adminPassword, int userType);

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
    DocumentSnapshot fsUser = await Firestore.instance.collection("Users").document(email).get();
    Firestore.instance.collection("Users").document(email).setData({'Last-login':DateTime.now()}, merge: true);
    return new UserProfile(fbUser: user, fsUser: fsUser);
  }

  Future<AuthResult> signUp(String email, String password, String adminPassword, int userType) async {
    //Usertypes, 99 -> Admin, 999 -> S.Admin, 1 -> Contractor, 2 -> Production, 3 -> Delivery
  
    return getCurrentUser().then((UserProfile x){
      return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password).then((AuthResult y){
          return Firestore.instance.collection("Users").document(email).setData({'Name': email.split('@')[0], 'Usertype': userType}).then((z){
            _firebaseAuth.signOut();
            return _firebaseAuth.signInWithEmailAndPassword(email: x.fbUser.email,password: adminPassword).then((AuthResult a){
              
            });
          });
        });
    });
  }

  Future<UserProfile> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    DocumentSnapshot fsUser = await Firestore.instance.collection("Users").document(user.email).get();
    return new UserProfile(fbUser: user, fsUser: fsUser);
  }

  Future<FirebaseUser> getFireBaseCurrentuser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  void deleteUser() async{
    String x;
    Firestore.instance.collection("Users").document(x).delete();
  }

  Future<UserProfile> getUserByEmail(String email) async{
    
    DocumentSnapshot fsUser = await Firestore.instance.collection("Users").document(email).get();
    return new UserProfile(fbUser:null, fsUser: fsUser);
  }

  Future<QuerySnapshot> getAllUsers() async{
    return getCurrentUser().then((UserProfile user){
      return Firestore.instance.collection("Users").getDocuments().then((QuerySnapshot users){
        switch(user.fsUser.data['Usertype']){
          case 99: 
                  users.documents.removeWhere((searchUser) => searchUser.data['Usertype'] == 99 || searchUser.data['Usertype'] == 999);
                  break;
          case 999: 
                  users.documents.removeWhere((searchUser)=> searchUser.data['Usertype'] == 999);
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