import 'dart:async';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/REST_Api/ServerApi.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BeruRegister {
  final StreamController registerController = StreamController<bool>();

  Timer timer;
  BeruRegister() {
    registerController.onPause = () => timer.cancel();
    registerController.onResume = timerSetUp;
    registerController.onListen = timerSetUp;
  }

  void timerSetUp() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      print("In Stream register Status in SignUp");
      try {
        var user = await FirebaseAuth.instance.currentUser();
        if (user != null) {
          if (await ServerApi.serverCheckIfExist()) {
            print("registed in server from Stream");
            registerController.sink.add(true);
            timer.cancel();
          }
        } else if (user == null) {
          print("No Firbase User");
          registerController.sink.add(false);
        }
      } on SighUpNotComplete {
        registerController.sink.add(false);
        timer.cancel();
      } on DioError {
        registerController.addError(BeruServerError());
      } on TimeoutException {
        registerController.addError(BeruServerError());
      } catch (e) {
        print(e);
        registerController.addError(e);
      }
    });
  }

  Stream<bool> get stream {
    return registerController.stream;
  }

  void dispose() {
    timer.cancel();
    registerController.close();
  }
}
