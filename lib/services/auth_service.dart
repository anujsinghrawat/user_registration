import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../screens/registration_page.dart';
import '../screens/login_page.dart';

class AuthService {

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) =>
          snapshot.hasData ? Register() : Login()),
    );
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }
}