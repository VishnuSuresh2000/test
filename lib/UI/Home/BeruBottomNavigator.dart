import 'package:beru/Responsive/CustomRatio.dart';
import 'package:flutter/material.dart';

class BeruBottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: ResponsiveRatio.getHight(50, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveRatio.getHight(25, context)),
            topRight: Radius.circular(ResponsiveRatio.getHight(25, context)),
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: ResponsiveRatio.getHight(50, context),
              width: MediaQuery.of(context).size.width / 2 - 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.green,
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.person,
                      color: Color(0xff676e79),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: ResponsiveRatio.getHight(50, context),
              width: MediaQuery.of(context).size.width / 2 - 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.shopping_basket,
                      color: Color(0xff676e79),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
