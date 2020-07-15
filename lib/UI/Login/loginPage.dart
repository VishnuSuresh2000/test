import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/userProvider.dart';
import 'package:beru/UI/Home/BeruHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruLogin extends StatefulWidget {
  @override
  _BeruLoginState createState() => _BeruLoginState();
}

class _BeruLoginState extends State<BeruLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {},
              child: Text("Test Section"),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
