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
      print("from Firebase lstener $event");
      if (event != null) {
        userFirbase = true;
        print("FireBase User");
        serverSignUpSbub.resume();
        firebaseSignUpSbub.pause();
      } else {
        userFirbase = false;
        print("No FireBase User from firebase instance");
      }
      print(" from stream $userFirbase $userSignUp");
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
      print("from lisenter SignUp Server $event");
      userSignUp = event;
      if (event) {
        print("paused stream sighnUp");
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
    userStatus =
        (userFirbase ?? false) && (userSignUp ?? false);
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

  void setData() async {
    var user = await FirebaseAuth.instance.currentUser();
    print("in the sec ${user.displayName}");
  }

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
}
