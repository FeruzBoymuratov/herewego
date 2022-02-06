import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/sign_up.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/utils_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  static final String id = "sign_in";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doLogIn(){
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty) return
    AuthService.signInUser(context, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser),
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async {
    if(firebaseUser != null){
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Utils.fireToast("Email yoki Password Xato!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              FlatButton(onPressed: (){
                _doLogIn();
              }, child: Text('Sign In',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold),),
              color: Colors.red,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Don't have an account?", style: TextStyle(fontWeight: FontWeight.bold),),
                  TextButton(onPressed: (){
                    Navigator.pushReplacementNamed(context, SignUpPage.id);
                  },
                      child: Text('Sign Up',
                        style: TextStyle(color: Colors.black),)),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
