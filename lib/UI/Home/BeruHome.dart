import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/UI/CommonFunctions/RouteParmeter.dart';
import 'package:beru/UI/Home/BeruDrawer.dart';
import 'package:beru/UI/Home/BeruHomeBody.dart';
import 'package:beru/UI/Home/BeruSerach.dart';
import 'package:beru/UI/Home/ShowCartButton.dart';
import 'package:beru/UI/Login/checkUserStatus.dart';
import 'package:beru/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BeruHome extends StatelessWidget {
  // final _controller = ScrollController();
  // _con
  static const String route = '/BeruHome';

  @override
  Widget build(BuildContext context) {
    print("called the build home function");
    return WillPopScope(
      onWillPop: () {
        print("Wiillpop executed");
        globalClose();
        return Future.value(false);
      },
      child: body(context),
    );
  }

  body(BuildContext context) {
    return Scaffold(
        drawer: BeruDrawer(),
        backgroundColor: Theme.of(context).backgroundColor,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: context.watch<UserState>().signOut,
        //   child: Image.asset(
        //     'assets/images/logo/logo.png',
        //     fit: BoxFit.fill,
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: BeruBottomNavigator(),
        body: CheckUserStatus(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              actionsIconTheme: Theme.of(context).appBarTheme.actionsIconTheme,
              iconTheme: Theme.of(context).appBarTheme.iconTheme,
              // leading: Icon(
              //   Icons.menu,
              // ),
              backgroundColor: Colors.white,
              centerTitle: true,
              pinned: true,
              // toolbarHeight: 110,
              collapsedHeight: 110,
              title: Text(
                "Beru",
              ),
              actions: [ShowCartButton()],
              // expandedHeight: 120,
              flexibleSpace: searchBar(),
            ),
            Selector<BloCForHome, BodyNav>(
              shouldRebuild: (previous, next) =>
                  previous.toString() != next.toString(),
              builder: (context, value, child) {
                print("selctor in home show body home");
                switch (value) {
                  // case BodyNav.first:
                  //   return BeruHomeBody();
                  //   break;
                  // case BodyNav.second:
                  //   return BeruProfile();
                  //   break;
                  default:
                    return BeruHomeBody();
                }
              },
              selector: (_, handler) => handler.select,
            ),
          ]),
        ));
  }

  Align searchBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: BeruSearchBar(),
      ),
    );
  }
}
