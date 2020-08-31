import 'dart:async';
import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/CustomeStream/StreamToCheckRegister.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/address.dart';
import 'package:beru/Schemas/BeruUser.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  BeruUser _user = BeruUser();
  final BeruRegister register = BeruRegister();
  StreamSubscription<bool> serverSignUpSbub;
  StreamSubscription<User> firebaseSignUpSbub;

  bool userFirbase;
  bool userSignUp;
  bool userStatus; //true siginin, false sigin out
  bool serverError = false;
  bool hasAddress;
  bool hasErrorUserDetails;
  Exception error;

  UserState() : super() {
    autoUserStatusCheck();
  }

  void loadUserDetails() async {
    try {
      _user = await ServerApi.getUserData();
      hasErrorUserDetails = false;
    } catch (e) {
      hasErrorUserDetails = true;
      error = e;
      print("Error from loading userData $e");
    } finally {
      notifyListeners();
    }
  }

  void autoUserStatusCheck() {
    firebaseSignUpSbub =
        FirebaseAuth.instance.authStateChanges().listen((event) async {
      // print("From Firbase Stream init $event");
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

  BeruUser get user {
    if (userSignUp) {
      if (_user.id == null) {
        print("user data load when that is not get");
        loadUserDetails();
      }
    }
    return _user;
  }

  void setTempData() {
    // print("setTemoData");
    if (userFirbase != null &&
        userFirbase &&
        userSignUp != null &&
        !userSignUp) {
      // print("setTemoData accesed condition");
      var user = FirebaseAuth.instance.currentUser;
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
      notifyListeners();
    });
  }

  Function siginInFirebase(String mode, BuildContext context) {
    return () async {
      showDialog(
        context: context,
        builder: (context) => beruLoadingBar(),
      );
      try {
        if (mode == "google") {
          if (await AuthServies().signinWithGoogle()) {
            Navigator.of(context).pop();
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
          Navigator.of(context).pop();
          print("$mode is not created yet");
          errorAlert(context, "$mode is not created yet");
        }
      } catch (e) {
        Navigator.of(context).pop();
        print("Error from siginInFirebase $e");
      }
    };
  }

  void registerToServer(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => beruLoadingBar(),
    );
    try {
      var res = await ServerApi.serverCreateUser(_user);
      Navigator.of(context).pop();
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
      Navigator.of(context).pop();
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
    showDialog(
      context: context,
      builder: (context) => beruLoadingBar(),
    );
    try {
      print("called the function add address");
      var res = await ServerApi.addAddress(address);
      Navigator.of(context).pop();
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
      Navigator.of(context).pop();
      print("Error from siginInFirebase $e");
      errorAlert(context, e.toString());
    }
  }
}
