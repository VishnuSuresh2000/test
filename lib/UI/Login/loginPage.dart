import 'package:beru/Auth/AuthServies.dart';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/Responsive/CustomRatio.dart';
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
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveRatio.getHight(60, context)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Back To Roots',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      fontStyle: FontStyle.italic),
                ),
                AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset(
                    "assets/images/logo/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                AspectRatio(aspectRatio: 8),
                LoginButton(
                  text: 'Sign in with',
                  img: 'assets/images/socialMedia/google.png',
                  callBack: Provider.of<UserState>(context, listen: false)
                      .siginInFirebase("google"),
                ),
                LoginButton(
                  text: 'Sign in with',
                  img: 'assets/images/socialMedia/facebook.png',
                  callBack: () {},
                ),
                Text(
                  '- OR -',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                LoginButton(
                  text: 'Sign in with',
                  img: 'assets/images/logo/logoZoom.png',
                  callBack: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({this.text, this.img, this.callBack});
  final String text;
  final String img;
  final Function callBack;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
            ResponsiveRatio.getWigth(70.0, context),
            ResponsiveRatio.getHight(15.0, context),
            ResponsiveRatio.getWigth(70.0, context),
            ResponsiveRatio.getHight(15.0, context)),
        onPressed: callBack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(text,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Image(
              image: AssetImage(img),
              height: ResponsiveRatio.getHight(34.0, context),
            ),
          ],
        ),
      ),
    );
  }
}
