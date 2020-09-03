import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';
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
    return Container(
      child: Center(
        child: FractionallySizedBox(
          heightFactor: 0.75,
          child: SizedBox(
            width: context.isMobile ? context.screenWidth : 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/logo/logo.png',
                    height: 70,
                  ),
                  fit: FlexFit.tight,
                  flex: 2,
                ),
                Flexible(
                  child: Text(
                    "Welcome to Beru",
                    style: GoogleFonts.openSans(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Flexible(
                  child: LoginButton(
                    text: "facebook",
                    boderColorShow: false,
                    background: Color(0xff635FFC),
                    callBack: () {},
                  ),
                  flex: 1,
                ),
                spacingFactor(),
                Flexible(
                  child: LoginButton(
                    text: "google",
                    boderColorShow: true,
                    background: Colors.white,
                    callBack: context
                        .watch<UserState>()
                        .siginInFirebase("google", context),
                  ),
                  flex: 1,
                ),
                spacingFactor(),
                Flexible(
                  child: LoginButton(
                    text: "beru",
                    boderColorShow: false,
                    background: Colors.grey[200],
                    callBack: () {},
                  ),
                  flex: 1,
                ),
                // spacingFactor(),
                // Flexible(
                //   child: Text(
                //     'Already a member? Log in',
                //     style: GoogleFonts.lato(
                //       fontWeight: FontWeight.bold,
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                //   flex: 1,
                // ),

                spacingFactor(),
                Flexible(
                  child: SizedBox(
                    width: 250,
                    child: StyledText(
                      textAlign: TextAlign.center,
                      text:
                          '<lato>By continuing, you agree to Beru\'s <bold> Terms of Service </bold>  and <bold> privacy policy </bold> </lato>',
                      styles: {
                        'lato': GoogleFonts.openSans(
                          fontSize: 10.0,
                        ),
                        'bold': GoogleFonts.openSans(
                            fontSize: 10.0, fontWeight: FontWeight.bold),
                      },
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Flexible spacingFactor() {
    return Flexible(
      fit: FlexFit.loose,
      child: 17.heightBox,
      flex: 1,
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({this.text, this.callBack, this.background, this.boderColorShow});
  final String text;
  final Color background;
  final Function callBack;
  final bool boderColorShow;
  @override
  Widget build(BuildContext context) {
    double scaleValue = 12.0;
    if (text == "facebook") {
      scaleValue = 25;
    } else if (text == "beru") {
      scaleValue = 12;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: InkWell(
        onTap: callBack,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              color: background,
              shape: BoxShape.rectangle,
              border: Border.all(
                  width: 1,
                  color:
                      boderColorShow ? Color(0xff4B4B4B) : Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                'assets/images/socialMedia/$text.png',
                scale: scaleValue,
              ),
              Text('Continue with ${text.firstLetterUpperCase()}',
                  style: GoogleFonts.openSans(
                          fontSize: 14.0, fontWeight: FontWeight.bold)
                      .copyWith(
                          color: text == "facebook"
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyText1.color)),
              10.widthBox
            ],
          ),
        ),
      ),
    );
  }
}
