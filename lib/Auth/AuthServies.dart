import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthServies {
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signinWithGoogle() async {
    try {
      var googleuser = await _googleSignIn.signIn();
      var googleAuth = await googleuser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      print("Error from google Sign in ${e.toString()}");
      throw e;
    }
  }

  static Future signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
