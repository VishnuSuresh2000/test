import 'package:beru/BLOC/CustomProviders/userProvider.dart';
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
        print("From Consumer ${value.userFirbase} ${value.userSignUp}");
        if (value == null || value.userFirbase == null) {
          return BeruLoadingBar();
        } else if (!value.userFirbase &&
            !(value.userSignUp ?? false)) {
          return BeruLogin();
        } else if (value.userSignUp == null) {
          return BeruLoadingBar();
        } else if (value.userFirbase && !value.userSignUp) {
          return BeruSignUp();
        } else if (value.userFirbase && value.userSignUp) {
          return test.child;
        } else if (value.serverError) {
          return BeruErrorPage(
            errMsg: value.error.toString(),
          );
        } else {
          return BeruLoadingBar();
        }
      },
    );
  }
}
