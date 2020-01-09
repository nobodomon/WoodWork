import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  UserProfile({this.fbUser, this.fsUser});
  FirebaseUser fbUser;
  DocumentSnapshot fsUser;
}