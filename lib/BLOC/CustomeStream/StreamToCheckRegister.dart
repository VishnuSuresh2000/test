import 'dart:async';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BeruRegister {
  StreamController<bool> registerController;
  bool load = true;
  BeruRegister() {
    registerController = StreamController<bool>(
      onListen: setUp,
      onResume: () {
        load = true;
        print("On Resume in Server Register");
        continueCheck();
      },
      onPause: () {
        load = false;
        print("on pause in server Register");
      },
      // onCancel: () {
      //   print("cancel Stream  in server Register");
      // },
    );

    //   load = true;
    //   continueCheck();
    // };
  }

  void setUp() async {
    print("called Server check function setUp");
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (await ServerApi.serverCheckIfExist()) {
          registerController.sink.add(true);
          load = false;
        }
      } else if (user == null) {
        registerController.sink.add(false);
      }
    } on SighUpNotComplete {
      registerController.sink.add(false);
      load = false;
    } on DioError {
      registerController.addError(BeruServerError());
      continueCheck();
    } on TimeoutException {
      registerController.addError(BeruServerError());
      continueCheck();
    } catch (e) {
      print("Error from register Server $e ");
      continueCheck();
      registerController.addError(e);
    }
  }

  Stream<bool> get stream {
    return registerController.stream;
  }

  void continueCheck() {
    if (load) {
      setUp();
    }
  }

  void dispose() {
    registerController.close();
  }
}
