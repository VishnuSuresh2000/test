import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/InterNetConectivity/NoInterNet.dart';
import 'package:beru/UI/Login/AddessAdding.dart';
import 'package:beru/UI/Login/loginPage.dart';
import 'package:beru/UI/Login/signUp.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class CheckUserStatus extends StatelessWidget {
  final Widget child;

  const CheckUserStatus({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print("Called build function in CheckUserStatus");
    return Selector2<
            ConnectivityResult,
            UserState,
            Tuple7<ConnectivityResult, String, String, String, bool, Exception,
                bool>>(
        child: child,
        builder: (context, value, child) {
          print("Called build function of selector in CheckUserStatus");
          if (value?.item1 == ConnectivityResult.none) {
            return NoInterNet();
          } else if (value.item2 == "false") {
            return BeruLogin();
          } else if (value.item3 == "false") {
            return BeruSignUp();
          } else if (value.item4 == "false") {
            return BeruAdddressAdding();
          } else if (value.item5) {
            return BeruErrorPage(
              errMsg: value.item6.toString(),
            );
          } else if ((value.item2 == "true") && (value.item3 == "true")) {
            return child;
          } else {
            return beruLoadingBar();
          }
        },
        shouldRebuild: (previous, next) =>
            (previous.item1 != next.item1) ||
            (previous.item7.toString() != next.item7.toString()),
        selector: (_, handler, handler2) => Tuple7(
            handler ?? null,
            handler2.userFirbase.toString(),
            handler2.userSignUp.toString(),
            handler2.hasAddress.toString(),
            handler2.serverError,
            handler2.error ?? null,
            handler2.state));
  }
}
