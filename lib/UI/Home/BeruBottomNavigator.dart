import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';
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
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.white,
        ),
        child: Selector<BloCForHome, Tuple2<BodyNav, Function>>(
          shouldRebuild: (previous, next) =>
              previous.item1.toString() != next.toString(),
          builder: (context, value, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.home,
                    color: value.item1 == BodyNav.first
                        ? Colors.green
                        : Color(0xff676e79),
                  ),
                  onPressed: () => value.item2(BodyNav.first)),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: value.item1 == BodyNav.second
                      ? Colors.green
                      : Color(0xff676e79),
                ),
                onPressed: () => value.item2(BodyNav.second),
              ),
              50.widthBox,
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: value.item1 == BodyNav.furth
                        ? Colors.green
                        : Color(0xff676e79),
                  ),
                  onPressed: () => value.item2(BodyNav.furth)),
              IconButton(
                icon: Icon(
                  Icons.shopping_basket,
                  color: value.item1 == BodyNav.fifth
                      ? Colors.green
                      : Color(0xff676e79),
                ),
                onPressed: () => value.item2(BodyNav.fifth),
              ),
            ],
          ),
          selector: (_, handler) => Tuple2(handler.select, handler.setBodynav),
        ),
      ),
    );
  }
}
