import 'package:beru/BLOC/userProvider.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/CommonFunctions/RouteParmeter.dart';
import 'package:beru/UI/Login/loginPage.dart';
import 'package:beru/UI/Login/signUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckUserStatus extends StatelessWidget {
  static const String route = '/checkUserStatus';
  final ParamsForOrginAndRoute parms;
  const CheckUserStatus({
    Key key,
    this.parms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ParamsForOrginAndRoute test =
        parms ?? ModalRoute.of(context).settings.arguments;
    return Consumer<UserState>(
      builder: (context, value, child) {
        print("From Consumer ${value.user.userFirbase} ${value.user.userSignUp}");
        if (value == null || value.user.userFirbase == null) {
          return BeruLoadingBar();
        } else if (!value.user.userFirbase &&
            !(value.user.userSignUp ?? false)) {
          return BeruLogin();
        } else if (value.user.userSignUp == null) {
          return BeruLoadingBar();
        } else if (value.user.userFirbase && !value.user.userSignUp) {
          return BeruSignUp();
        } else if (value.user.userFirbase && value.user.userSignUp) {
          return test.child;
        } else if (value.user.serverError) {
          return BeruErrorPage(
            errMsg: value.user.error.toString(),
          );
        } else {
          return BeruLoadingBar();
        }
      },
    );
  }
}
