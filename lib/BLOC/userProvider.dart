import 'dart:async';

import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/StreamToCheckRegister.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  final User _user = User();
  final BeruRegister register = BeruRegister();
  StreamSubscription<bool> serverSignUpSbub;
  StreamSubscription<FirebaseUser> firebaseSignUpSbub;

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
        _user.userFirbase = true;
        print("FireBase User");
        serverSignUpSbub.resume();
        firebaseSignUpSbub.pause();
      } else {
        _user.userFirbase = false;
        print("No FireBase User from firebase instance");
      }
      print(" from stream ${_user.userFirbase} ${_user.userSignUp}");
      setUserStatus();
      notifyListeners();
    }, onError: (error) {
      print(error);
      _user.serverError = true;
      _user.error = BeruFirebaseError();
      setUserStatus();
      notifyListeners();
    });
  }

  void checkUserInServer() {
    serverSignUpSbub = register.stream.listen((event) {
      print("from lisenter SignUp Server $event");
      _user.userSignUp = event;
      if (event) {
        print("paused stream sighnUp");
        serverSignUpSbub.pause();
      }
      setUserStatus();
      notifyListeners();
    }, onError: (error) {
      if (error is BeruServerError) {
        _user.serverError = true;
        _user.error = BeruServerError();
      } else {
        _user.serverError = true;
        _user.error = error;
      }
      setUserStatus();
      notifyListeners();
    });
  }

  void setUserStatus() {
    _user.userStatus =
        (_user.userFirbase ?? false) && (_user.userSignUp ?? false);
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
    user.userFirbase = value;
    serverSignUpSbub.resume();
    notifyListeners();
  }

  set siginUpServer(bool value) {
    serverSignUpSbub.pause();
    user.userSignUp = value;
    setUserStatus();
    notifyListeners();
  }

  bool get userStatus {
    return user.userStatus;
  }

  void signOut() {
    bool value = false;
    AuthServies.signOut();
    serverSignUpSbub.pause();
    firebaseSignUpSbub.resume();
    user.userStatus = value;
    user.userFirbase = value;
    user.userSignUp = null;
    notifyListeners();
  }
}
