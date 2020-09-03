import 'package:beru/UI/Cart/ShowProductInCart.dart';
import 'package:beru/UI/Home/BeruHome.dart';
import 'package:beru/UI/InterNetConectivity/NoInterNet.dart';
import 'package:beru/UI/Product/ShowProduct.dart';
import 'package:beru/UI/Profile/BeruProfileView.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

transitionOnRoute(RouteSettings settings) {
  switch (settings.name) {
    case BeruHome.route:
      return defalutTransition(BeruHome(), settings);
      break;
    // case CheckUserStatus.route:
    //   return defalutTransition(CheckUserStatus(), settings);
    // break;
    case NoInterNet.route:
      return defalutTransition(NoInterNet(), settings);
      break;
    case ShowProducts.route:
      return defalutTransition(ShowProducts(), settings);
      break;
    case BeruProfile.route:
      return defalutTransition(BeruProfile(), settings);
      break;
    case ShowProductsInCart.route:
      return defalutTransition(ShowProductsInCart(), settings);
      break;
  }
}

defalutTransition(Widget page, RouteSettings settings) {
  return PageTransition(
      child: page,
      type: PageTransitionType.leftToRightWithFade,
      settings: settings);
}
