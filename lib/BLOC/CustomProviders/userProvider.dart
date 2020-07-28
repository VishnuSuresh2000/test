import 'dart:async';

import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/CustomeStream/StreamToCheckRegister.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/address.dart';
import 'package:beru/Schemas/user.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
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
  bool hasAddress;
  Exception error;

  UserState() : super() {
    autoUserStatusCheck();
  }

  void autoUserStatusCheck() {
    firebaseSignUpSbub =
        FirebaseAuth.instance.onAuthStateChanged.listen((event) async {
      print("From Firbase Stream init $event");
      if (event != null) {
        print("Data  ${event.displayName ?? null}");
        userFirbase = true;

        if (serverSignUpSbub == null) {
          print("init the server check stream");
          checkUserInServer();
        } else {
          if (serverSignUpSbub.isPaused) {
            print("And is paused / Resume the server check stream");
            serverSignUpSbub.resume();
          }
          // checkUserInServer();
        }
        if (!firebaseSignUpSbub.isPaused) {
          firebaseSignUpSbub.pause();
        }
      } else {
        userFirbase = false;
        if (!firebaseSignUpSbub.isPaused) {
          firebaseSignUpSbub.pause();
        }
      }

      setUserStatus();
      notifyListeners();
    }, onError: (error) {
      print("From Firbase Stream $error");
      serverError = true;
      error = BeruFirebaseError();
      setUserStatus();
      notifyListeners();
    });
  }

  void checkUserInServer() {
    serverSignUpSbub = register.stream.listen((event) {
      print("Stream From ServerSignUp $event");
      userSignUp = event;
      if (!event) {
        print("No user registerd Stream From ServerSignUp");
        setTempData();
      }
      if (event) {
        checkHasAddress();
      }
      if (!serverSignUpSbub.isPaused) {
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

  User get user {
    return _user;
  }

  void setTempData() async {
    // print("setTemoData");
    if (userFirbase != null &&
        userFirbase &&
        userSignUp != null &&
        !userSignUp) {
      // print("setTemoData accesed condition");
      var user = await FirebaseAuth.instance.currentUser();
      _user.firstName = user.displayName.split(' ')[0] ?? null;
      _user.lastName = user.displayName.split(' ')[1] ?? null;
      _user.email = user.email;
      notifyListeners();
      try {
        _user.phoneNumber =
            user.phoneNumber != null ? int.parse(user.phoneNumber) : null;
      } catch (e) {
        print("Error from setTemp $e");
      }
      print("${_user.firstName} ${_user.lastName}");
      notifyListeners();
    }
  }

  set siginInFirbase(bool value) {
    userFirbase = value;
    if (serverSignUpSbub == null) {
      print("init the server check stream");
      checkUserInServer();
    } else {
      print("resume signinfirebase the server check stream");
      if (serverSignUpSbub.isPaused) {
        serverSignUpSbub.resume();
      }
    }
    if (!firebaseSignUpSbub.isPaused) {
      firebaseSignUpSbub.pause();
    }

    notifyListeners();
  }

  set siginUpServer(bool value) {
    if (!serverSignUpSbub.isPaused) {
      serverSignUpSbub.pause();
    }
    userSignUp = value;
    this.hasAddress = false;
    setUserStatus();
    notifyListeners();
  }

  void signOut() {
    print("Sign Out is called");
    AuthServies.signOut().then((value) {
      print("Sign Out is Complted");
      userStatus = false;
      userFirbase = false;
      userSignUp = null;
      this.hasAddress = null;
      if (!serverSignUpSbub.isPaused) {
        serverSignUpSbub.pause();
      }
      // if (firebaseSignUpSbub.isPaused) {
      //   print("firebase Stream is called");
      //   firebaseSignUpSbub.resume();
      // }
      notifyListeners();
    });
  }

  Function siginInFirebase(String mode, BuildContext context) {
    return () async {
      try {
        if (mode == "google") {
          if (await AuthServies().signinWithGoogle()) {
            alertWithCallBack(
                context: context,
                content: "Sign Up Completed",
                callBackName: "Continue",
                cakllback: () {
                  this.siginInFirbase = true;
                  Navigator.of(context).pop();
                });
          }
        } else {
          print("$mode is not created yet");
        }
      } catch (e) {
        print("Error from siginInFirebase $e");
      }
    };
  }

  void registerToServer(BuildContext context) async {
    try {
      var res = await ServerApi.serverCreateUser(_user);
      alertWithCallBack(
          context: context,
          content: res.toString(),
          callBackName: "Continue",
          cakllback: () {
            this.siginUpServer = true;
            Navigator.of(context).pop();
          });
    } catch (e) {
      print("Error from siginInFirebase $e");
      errorAlert(context, e.toString());
    }
  }

  @override
  void dispose() {
    firebaseSignUpSbub.cancel();
    serverSignUpSbub.cancel();
    register.dispose();
    super.dispose();
  }

  void checkHasAddress() async {
    try {
      print("called the function CheckHass address");
      this.hasAddress = await ServerApi.serverCheckhasAddress();
      notifyListeners();
    } catch (e) {
      print("Error from Check has address $e");
      checkHasAddress();
    }
  }

  void addAddressToUser(Address address, BuildContext context) async {
    try {
      print("called the function add address");
      var res = await ServerApi.addAddress(address);
      alertWithCallBack(
          context: context,
          content: res.toString(),
          callBackName: "Continue",
          cakllback: () {
            this.hasAddress = true;
            notifyListeners();
            Navigator.of(context).pop();
          });
    } catch (e) {
      print("Error from siginInFirebase $e");
      errorAlert(context, e.toString());
    }
  }
}
