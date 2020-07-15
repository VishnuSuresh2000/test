import 'dart:async';
import 'dart:convert';

import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/DataStructures/BeruServerError.dart';

import 'package:beru/Schemas/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServerApi {
  static BaseOptions _options = BaseOptions(
    baseUrl: "http://192.168.43.220:80",
  );
  static Dio _client = Dio(_options);

  static tokenForServer() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      return (await (await FirebaseAuth.instance.currentUser())
              .getIdToken(refresh: true))
          .token;
    } else {
      throw NoUserException();
    }
  }

  // static test() async {
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   var token = await user.getIdToken();
  //   print(token.token);
  //   Response res = await _client.get('/customer/test/',
  //       options: Options(headers: {"authorization": "Bearer ${token.token}"}));
  //   print(res);
  // }

  static void serverGet() async {
    try {
      // var head = "Bearer ${await tokenForServer()}";
      Response res = await _client.get(
        '/customer/create',
        // options: Options(headers: {"authorization": head})
      );
      print(res.data);
    } on NoUserException catch (e) {
      print(e.errMsg().toString() + "custom error");
    } on DioError catch (e) {
      print(e.response.data.toString() + "dio error");
    } catch (e) {
      print(e);
    } finally {}
  }

  static Future<bool> serverCheckIfExist() async {
    try {
      var head = "Bearer ${await tokenForServer()}";
      Response res = await _client
          .get('/customer/checkForExist',
              options: Options(headers: {"authorization": head}))
          .timeout(Duration(seconds: 20));
      print(res.data);
      return res.data['data'];
    } on NoUserException catch (e) {
      print(e.errMsg().toString() + "custom error");
      throw e;
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + "dio error");
      if (e.response.data['data'] == BeruServerErrorStrings.userMustSignUp) {
        throw SighUpNotComplete();
      } else {
        throw e;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static serverCreateUser(User user) async {
    try {
      print(user.toMap());
      var head = "Bearer ${await tokenForServer()}";
      Response res = await _client
          .post('/customer/create',
              data: jsonEncode(user.toMap()),
              options: Options(headers: {"authorization": head}))
          .timeout(Duration(seconds: 30));
      return res.data['data'];
    } on NoUserException catch (e) {
      print(e.errMsg().toString() + "custom error");
      throw e;
    } on DioError catch (e) {
      print(e.response.data.toString() + "dio error");
      throw e;
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    } finally {}
  }
}
