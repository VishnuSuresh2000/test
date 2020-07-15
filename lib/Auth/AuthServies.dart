import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  static signOut() {
    FirebaseAuth.instance.signOut();
  }

  static bool checkIsAlredyAccount() {
    return true;
  }
}
