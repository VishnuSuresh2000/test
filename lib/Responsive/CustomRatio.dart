import 'package:flutter/cupertino.dart';

class ResponsiveRatio {
  static const double _devWidth = 432.0;
  static const double _devHeight = 816.0;
  static double getHight(double height, BuildContext context) {
    return ((height / _devHeight) * MediaQuery.of(context).size.height);
  }

  static double getWigth(double width, BuildContext context) {
    return ((width / _devWidth) * MediaQuery.of(context).size.width);
  }
}
