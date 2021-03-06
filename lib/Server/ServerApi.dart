import 'dart:async';
import 'dart:convert';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/DataStructures/BeruServerError.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Cart.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Schemas/address.dart';
import 'package:beru/Schemas/BeruUser.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ServerApi {
  static bool offlineOnline = false;
  static String switchWeb = kIsWeb ? "localhost:80" : "192.168.43.144:80";
  static String dns =
      offlineOnline ? "$switchWeb" : "api.beru.co.in";
  static String url = offlineOnline ? "http://$dns" : "https://$dns";
  static BaseOptions _options = BaseOptions(
    baseUrl: url,
    connectTimeout: 3000,
  );
  static Dio _client = Dio(_options);

  static tokenForServer() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return await FirebaseAuth.instance.currentUser.getIdToken(true);
    } else {
      throw NoUserException();
    }
  }

  static Future<Map<String, bool>> serverCheckIfExist() async {
    try {
      var head = "Bearer ${await tokenForServer()}";
      Response res = await _client.get('/customer/checkForExist',
          options: Options(headers: {"authorization": head}));
      print("data from server  serverCheckIfExist ${res.data['data']}");
      return Map.from(res.data['data']);
    } on NoUserException catch (e) {
      print(e.errMsg().toString() + " custom error");
      throw e;
    } on DioError catch (e) {
      print(e.response.data.toString() + " dio error");
      if (e.response.data['data'] == BeruServerErrorStrings.userMustSignUp) {
        throw SighUpNotComplete();
      } else {
        throw BeruUnKnownError(error: e.response.data['data'].toString());
      }
    } catch (e) {
      print("error from  serverCheckIfExist $e");
      throw e;
    }
  }

  static serverCreateUser(BeruUser user) async {
    try {
      print(user.toMap());
      var head = "Bearer ${await tokenForServer()}";
      Response res = await _client.post('/customer/create',
          data: jsonEncode(user.toMapForBUserRegister()),
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
      if (e.response.data['data'] ==
              BeruServerErrorStrings.noProductForSalles ||
          e.response.data['data'] == BeruServerErrorStrings.noRecordFound) {
        throw BeruNoProductForSalles();
      } else {
        throw BeruUnKnownError(error: e.response.data['data'].toString());
      }
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Product>> serverGetSallesProduct() async {
    print("on the server call of product");
    try {
      Response res = await _client.get('/customer/salles/data',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}));
      // print("the data from ${res?.data}");
      // if (res?.data['data'] == null) {
      //   print("no data get");
      //   return await serverGetSallesProduct();
      // }
      List data = res.data['data'];
      return data.map((e) => Product.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.response.data['data'] ==
              BeruServerErrorStrings.noProductForSalles ||
          e.response.data['data'] == BeruServerErrorStrings.noRecordFound) {
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
      print(e.response.data['data'].toString() + " dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Map<String, dynamic>> addMultiProductToCart(
      List<Cart> carts) async {
    try {
      Response res = await _client.post('/customer/cart/addMultiCart',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}),
          data: json.encode(carts.map((e) => e.toMapCreate()).toList()));
      print("serverGetCart data : ${res?.data}");
      return res.data['data'];
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + " dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Map<String, dynamic>> conformDelivary() async {
    try {
      Response res = await _client.put(
        '/customer/cart/addMultiPayment',
        options: Options(
            headers: {"authorization": "Bearer ${await tokenForServer()}"}),
      );
      print("serverGetCart data : ${res?.data}");
      return res.data['data'];
    } on DioError catch (e) {
      print(e.response.data['data'].toString() + " dio error");
      throw BeruUnKnownError(error: e.response.data['data'].toString());
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<List<Cart>> serverGetCart() async {
    print("on the server call of Cart");
    try {
      Response res = await _client.get('/customer/cart/data',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}));
      // print("serverGetCart data : ${res?.data}");
      List data = res.data['data'];
      return data.map((e) => Cart.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.response.data['data'] ==
              BeruServerErrorStrings.noProductForSalles ||
          e.response.data['data'] == BeruServerErrorStrings.noRecordFound) {
        throw BeruNoProductForSalles();
      } else {
        throw BeruUnKnownError(error: e.response.data['data'].toString());
      }
    } on TimeoutException {
      throw BeruServerError();
    } catch (e) {
      print("Error from serverGetCart : $e");
      throw e;
    }
  }

  static Future<String> addSingleIteamToBag(Cart data) async {
    try {
      Response res = await _client.post('/customer/cart/add',
          options: Options(
              headers: {"authorization": "Bearer ${await tokenForServer()}"}),
          data: json.encode(data.toMapCreate()));
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

  static Future<BeruUser> getUserData() async {
    try {
      Response res = await _client.get(
        '/customer/userData',
        options: Options(
            headers: {"authorization": "Bearer ${await tokenForServer()}"}),
      );
      return BeruUser.fromMap(res.data['data']);
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
