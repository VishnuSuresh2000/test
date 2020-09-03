import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/CustomProviders/BlocForFirbase.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruUser.dart';
import 'package:beru/Schemas/address.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  BeruUser _user = BeruUser();

  FirebaseData _firebaseData = FirebaseData();
  bool userFirbase;
  bool userSignUp;
//true siginin, false sigin out
  bool serverError=false;
  bool hasAddress;
  bool hasErrorUserDetails;
  bool state = false;
  // bool loading = false;
  Exception error;

  update(FirebaseData data) {
    if (_firebaseData.state.toString() != data.state.toString()) {
      // print("Data State Changed ${_firebaseData.state} ${data.state}");
      _firebaseData = data;
      initUserState();
    }
  }

  initUserState() async {
    if (_firebaseData.user == null) {
      userFirbase = false;
      userSignUp = false;
      hasAddress = false;
      state = !state;
      notifyListeners();
    } else if (_firebaseData.user != null) {
      userFirbase = true;
      initServerCheck();
    }
  }

  initServerCheck() async {
    try {
      var res = await ServerApi.serverCheckIfExist();
      userSignUp = res['user'] ?? false;
      hasAddress = res['address'] ?? false;
      serverError = false;
    } on SighUpNotComplete {
      print("Not completed the registration");
      userSignUp = false;
      hasAddress = false;
      serverError = false;
    } catch (e) {
      print("error from initServerCheck server UserState $e");
      serverError = true;
      error = e is Exception ?e :BeruUnKnownError(error: e.toString());
    } finally {
      if (userSignUp != null && !userSignUp) {
        setTempData();
      } else {
        state = !state;
        notifyListeners();
      }
      if (serverError) {
        print("error from initServerCheck server UserState and recalling");
        initServerCheck();
      }
    }
  }

  UserState() : super();

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
      try {
        _user.phoneNumber =
            user.phoneNumber != null ? int.parse(user.phoneNumber) : null;
      } catch (e) {
        print("Error from setTemp $e");
      } finally {
        print("${_user.firstName} ${_user.lastName}");
        state = !state;
        notifyListeners();
      }
    }
  }

  set siginInFirbase(bool value) {
    userFirbase = value;
    initServerCheck();

    // notifyListeners();
  }

  set siginUpServer(bool value) {
    userSignUp = value;
    this.hasAddress = false;
    state = !state;
    notifyListeners();
  }

  void signOut() {
    print("Sign Out is called");
    AuthServies.signOut().then((value) {
      print("Sign Out is Complted");
      userFirbase = false;
      userSignUp = null;
      this.hasAddress = null;
      state = !state;
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
    super.dispose();
  }

  // void checkHasAddress() async {
  //   try {
  //     print("called the function CheckHass address");
  //     this.hasAddress = await ServerApi.serverCheckhasAddress();
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error from Check has address $e");
  //     checkHasAddress();
  //   }
  // }

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
            state = !state;
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
