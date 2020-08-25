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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Center(
          child: FractionallySizedBox(
            heightFactor: 0.75,
            child: SizedBox(
              width: context.isMobile ? context.screenWidth : 380,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset('assets/images/logo/logo.png'),
                    flex: 2,
                  ),
                  Flexible(
                    child: Text(
                      "Welcome to Beru",
                      style: GoogleFonts.lato(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
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
                        text:
                            '<lato>By continuing, you agree to Beru\'s <bold> Terms of Service </bold>  and <bold> privacy policy </bold> </lato>',
                        styles: {
                          'lato': GoogleFonts.lato(
                            fontSize: 12.0,
                          ),
                          'bold': GoogleFonts.lato(
                              fontSize: 12.0, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Flexible spacingFactor() {
    return Flexible(
      fit: FlexFit.loose,
      child: 25.heightBox,
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
          decoration: BoxDecoration(
              color: background,
              shape: BoxShape.rectangle,
              border: Border.all(
                  color: boderColorShow ? Colors.black : Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  'assets/images/socialMedia/$text.png',
                  scale: scaleValue,
                ),
              ),
              AspectRatio(aspectRatio: 0.5),
              Text(
                'Continue with ${text.firstLetterUpperCase()}',
                style: GoogleFonts.lato(
                        fontSize: 13.0, fontWeight: FontWeight.bold)
                    .copyWith(
                        color: text == "facebook"
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyText1.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
