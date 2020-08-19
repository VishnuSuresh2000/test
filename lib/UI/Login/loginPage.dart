import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeruLogin extends StatefulWidget {
  @override
  _BeruLoginState createState() => _BeruLoginState();
}

class _BeruLoginState extends State<BeruLogin> {
  @override
  Widget build(BuildContext context) {
    print("Is Mobile ${context.isMobile}\n${context.mdDeviceSize}");
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return Container(
              height: context.isMobile
                  ? context.percentHeight * 100
                  : context.percentHeight * 90,
              width: context.isMobile ? context.percentWidth * 100 : 380,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
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
                            .siginInFirebase("google", context),
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
            );
          },
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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        onPressed: callBack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(text,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Image(
              image: AssetImage(img),
              height: context.safePercentHeight * 5,
            ),
          ],
        ),
      ),
    );
  }
}
