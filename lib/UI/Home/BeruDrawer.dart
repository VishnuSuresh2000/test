import 'package:beru/UI/Profile/BeruProfileView.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).accentColor,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Card(
                          shape: CircleBorder(),
                          child: Image.asset(
                            'assets/images/logo/logo.png',
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: "Beru"
                        .text
                        .textStyle(Theme.of(context)
                            .appBarTheme
                            .textTheme
                            .headline6
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16))
                        .make(),
                  ))
                ],
              ),
            ),
          ),
          RaisedButton(
            onPressed: () => context.nav.pushNamed(BeruProfile.route),
            child: "Profile".text.make(),
          )
        ],
      ),
    );
  }
}
