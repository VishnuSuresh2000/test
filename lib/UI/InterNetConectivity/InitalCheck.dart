import 'package:beru/UI/CommonFunctions/RouteParmeter.dart';
import 'package:beru/UI/Home/BeruHome.dart';
import 'package:beru/UI/InterNetConectivity/CheckConnectivity.dart';
import 'package:beru/UI/Login/checkUserStatus.dart';
import 'package:flutter/material.dart';

class InitalCheck extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return checkInterNet(CheckUserStatus(
      parms: ParamsForOrginAndRoute(
        child: BeruHome()
      ),
    ));
  }
}


