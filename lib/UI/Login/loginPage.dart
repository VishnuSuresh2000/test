import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/UI/Home/BeruHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruLogin extends StatefulWidget {
  @override
  _BeruLoginState createState() => _BeruLoginState();
}

class _BeruLoginState extends State<BeruLogin> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () async {
                try {
                  if (await AuthServies().signinWithGoogle()) {
                    print("Google Sign Complted");
                    Provider.of<UserState>(context, listen: false)
                        .siginInFirbase = true;
                  }
                } catch (e) {
                  scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text("$e")));
                  print("Error from login $e");
                }
              },
              child: Text("Google Sign"),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(BeruHome.route, (route) => false),
              child: Text("Skip"),
            ),
            RaisedButton(
              onPressed: () {
                // Scaffold.of(context).showSnackBar();
                scaffoldKey.currentState
                    .showSnackBar(SnackBar(content: Text("Just Test")));
              },
              child: Text("Test Section"),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
