import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:herewego/pages/sign_in.dart';
import 'package:herewego/services/prefs_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  /* Sign In User */
  //****************************************************************************
  static Future<FirebaseUser> signInUser(BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser firebaseUser = _auth.currentUser as FirebaseUser;
      return firebaseUser;
    } catch (e) {
      print('Error SignInUser : $e');
    }
    return null;
  }
  //****************************************************************************


  /* Sign Up User */
  //****************************************************************************
  static Future<FirebaseUser> signUpUser(BuildContext context, String name, String email, String password) async {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseUser firebaseUser = _auth.currentUser as FirebaseUser;
      return firebaseUser;
    } catch (e) {
      print('Error SignUpUser : $e');
    }
    return null;
  }
  //****************************************************************************


  /* Sign Out User */
  //****************************************************************************
  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((_) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
//****************************************************************************
}