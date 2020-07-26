import 'dart:async';
import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/CustomeStream/StreamToCheckRegister.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  final User _user = User();
  final BeruRegister register = BeruRegister();
  StreamSubscription<bool> serverSignUpSbub;
  StreamSubscription<FirebaseUser> firebaseSignUpSbub;

  bool userFirbase;
  bool userSignUp;
  bool userStatus; //true siginin, false sigin out
  bool serverError = false;
  Exception error;

  UserState() : super() {
    autoUserStatusCheck();
    checkUserInServer();
    serverSignUpSbub.pause();
  }

  void autoUserStatusCheck() {
    firebaseSignUpSbub =
        FirebaseAuth.instance.onAuthStateChanged.listen((event) async {
      if (event != null) {
        userFirbase = true;

        serverSignUpSbub.resume();
        firebaseSignUpSbub.pause();
      } else {
        userFirbase = false;
      }

      setUserStatus();
      notifyListeners();
    }, onError: (error) {
      print(error);
      serverError = true;
      error = BeruFirebaseError();
      setUserStatus();
      notifyListeners();
    });
  }

  void checkUserInServer() {
    serverSignUpSbub = register.stream.listen((event) {
      userSignUp = event;
      if (event) {
        serverSignUpSbub.pause();
      }
      setUserStatus();
      notifyListeners();
    }, onError: (error) {
      if (error is BeruServerError) {
        serverError = true;
        error = BeruServerError();
      } else {
        serverError = true;
        error = error;
      }
      setUserStatus();
      notifyListeners();
    });
  }

  void setUserStatus() {
    userStatus = (userFirbase ?? false) && (userSignUp ?? false);
    notifyListeners();
  }

  void setMailItemas(String fullname, String email, var phoneNumber) {
    _user.firstName = fullname.split(' ')[0];
    _user.lastName = fullname.split(' ')[1];
    _user.email = email;
    try {
      _user.phoneNumber = int.parse(phoneNumber);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  User get user {
    return _user;
  }

  // void setData() async {
  //   var user = await FirebaseAuth.instance.currentUser();

  // }

  set siginInFirbase(bool value) {
    userFirbase = value;
    serverSignUpSbub.resume();
    notifyListeners();
  }

  set siginUpServer(bool value) {
    serverSignUpSbub.pause();
    userSignUp = value;
    setUserStatus();
    notifyListeners();
  }

  void signOut() {
    bool value = false;
    AuthServies.signOut();
    serverSignUpSbub.pause();
    firebaseSignUpSbub.resume();
    userStatus = value;
    userFirbase = value;
    userSignUp = null;
    notifyListeners();
  }

  Function siginInFirebase(String mode) {
    return () async {
      try {
        if (mode == "google") {
          if (await AuthServies().signinWithGoogle()) {
            this.siginInFirbase = true;
          }
        } else {
          print("$mode is not created yet");
        }
      } catch (e) {
        print("Error from siginInFirebase $e");
      }
    };
  }

  @override
  void dispose() {
    firebaseSignUpSbub.cancel();
    serverSignUpSbub.cancel();
    register.dispose();
    super.dispose();
  }
}
