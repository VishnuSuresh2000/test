import 'dart:async';
import 'dart:convert';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/DataStructures/BeruServerError.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Cart.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Schemas/address.dart';
import 'package:beru/Schemas/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ServerApi {
  static bool offlineOnline = false;
  static String switchWeb = kIsWeb ? "localhost:80" : "192.168.43.220:80";
  static String dns =
      offlineOnline ? "$switchWeb" : "beru-server.herokuapp.com";
  static String url = offlineOnline ? "http://$dns" : "https://$dns";
  static BaseOptions _options = BaseOptions(
    baseUrl: url,
    connectTimeout: 3000,
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

  static Future<bool> serverCheckIfExist() async {
    try {
      var head = "Bearer ${await tokenForServer()}";
      Response res = await _client.get('/customer/checkForExist',
          options: Options(headers: {"authorization": head}));
      return res.data['data'];
    } on NoUserException catch (e) {
      print(e.errMsg().toString() + "custom error");
      throw e;
    } on DioError catch (e) {
      print(e.response.data.toString() + "dio error");
      if (e.response.data['data'] == BeruServerErrorStrings.userMustSignUp) {
        throw SighUpNotComplete();
      } else {
        throw BeruUnKnownError(error: e.response.data['data'].toString());
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
      Response res = await _client.post('/customer/create',
          data: jsonEncode(user.toMapForUserRegister()),
          options: Options(headers: {"authorization": head}));
      return res.data['data'];
    } on NoUserException catch (e) {
      print(e.errMsg().toString() + "custom error");
      throw e;
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + "dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    } finally {}
  }

  static Future<List<BeruCategory>> serverGetCategory() async {
    try {
      Response res = await _client.get('/category/data');
      List temp = res.data['data'];
      return temp.map((e) => BeruCategory.fromMap(e)).toList();
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + "dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Product>> serverGetSallesProductByCategory(
      String category) async {
    try {
      Response res = await _client.get(
          '/customer/salles/dataByCategory/$category',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}));
      List data = res.data['data'];
      return data.map((e) => Product.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.response.data['data'] ==
          BeruServerErrorStrings.noProductForSalles) {
        throw BeruNoProductForSalles();
      } else {
        throw BeruUnKnownError(error: e.response.data['data'].toString());
      }
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print("Error from serverGetSallesProductByCategory : $e");
      throw e;
    }
  }

  static Future<bool> serverCheckhasAddress() async {
    try {
      Response res = await _client.get('/customer/hasAddress',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}));
      return res.data['data'];
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + "dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<String> addAddress(Address data) async {
    try {
      Response res = await _client.put('/customer/addAddress',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}),
          data: json.encode(data.toMap()));
      return res.data['data'];
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + "dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<String> addToCart(Cart cart) async {
    try {
      Response res = await _client.post('/customer/cart/add',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}),
          data: json.encode(cart.toMapCreate()));
      return res.data['data'];
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + "dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
