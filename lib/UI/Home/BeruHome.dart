import 'package:beru/BLOC/userProvider.dart';
import 'package:beru/REST_Api/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/RouteParmeter.dart';
import 'package:beru/UI/InterNetConectivity/CheckConnectivity.dart';
import 'package:beru/UI/Login/checkUserStatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruHome extends StatefulWidget {
  static const String route = '/BeruHome';
  @override
  _BeruHomeState createState() => _BeruHomeState();
}

class _BeruHomeState extends State<BeruHome> {
  @override
  Widget build(BuildContext context) {
    return checkInterNet(home());
  }

  Scaffold home() {
    return Scaffold(
      body: Center(
        child: Container(
          child:columnTest(),
        ),
      ),
    );
  }

  Column columnTest() {
    return Column(
      children: [
        Text("Home Page"),
        SizedBox.fromSize(
          size: Size.fromHeight(30),
        ),
        SizedBox.fromSize(
          size: Size.fromHeight(30),
        ),
        Consumer<UserState>(
          builder: (context, value, child) {
            if (value.userStatus != null && value.userStatus) {
              return RaisedButton(
                onPressed: () => Provider.of<UserState>(context,listen: false).signOut(),
                child: Text("sign Out"),
              );
            } else {
              return RaisedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(CheckUserStatus.route,arguments: ParamsForOrginAndRoute(
                      child: BeruHome(),
                      childRoute: BeruHome.route,
                    )),
                child: Text("sign In"),
              );
            }
          },
        ),
        SizedBox.fromSize(
          size: Size.fromHeight(30),
        ),
        RaisedButton(
          onPressed: () async => ServerApi.serverGet(),
          child: Text("Server Test"),
        )
      ],
    );
  }
}
