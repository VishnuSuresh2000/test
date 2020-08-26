import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/CustomFunctions/BeruString.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Home/BeruBottomNavigator.dart';
import 'package:beru/UI/InterNetConectivity/CheckConnectivity.dart';
import 'package:beru/UI/Product/ShowProduct.dart';
import 'package:beru/main.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruHome extends StatefulWidget {
  static const String route = '/BeruHome';
  @override
  _BeruHomeState createState() => _BeruHomeState();
}

class _BeruHomeState extends State<BeruHome> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("Wiillpop executed");
          globalClose();
          return Future.value(false);
        },
        child: checkInterNet(body(context)));
  }

  body(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: context.watch<UserState>().signOut,
          child: Image.asset(
            'assets/images/logo/logo.png',
            fit: BoxFit.fill,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BeruBottomNavigator(),
        body: nestedScrollView());
  }

  Consumer getCategory(BuildContext context) {
    return Consumer<BlocForCategory>(
      builder: (context, value, child) {
        if (value == null || value.data.loading) {
          return beruLoadingBar();
        } else if (value.data.isError) {
          return BeruErrorPage(
            errMsg: value.data.error.toString(),
          );
        } else {
          return GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 20),
            crossAxisCount: 2,
            primary: false,
            shrinkWrap: true,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 15.0,
            childAspectRatio: 1,
            children:
                value.data.list.map((e) => showCategory(e, context)).toList(),
          );
        }
      },
    );
  }

  Widget showCategory(BeruCategory e, BuildContext context) {
    return Selector<BloCForHome, Function>(
      shouldRebuild: (previous, next) => false,
      selector: (_, handler) => handler.setCategory,
      builder: (context, value, child) {
        return InkWell(
          onTap: () {
            value(e);
            context.nav.pushNamed(ShowProducts.route);
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 2,
                    child: e.hasImg
                        ? Image.network(
                            "${ServerApi.url}/category/getImage/${e.id}",
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                "$error".text.bold.make().centered(),
                          )
                        : Image.asset(
                            "assets/images/NoImg.png",
                            fit: BoxFit.contain,
                          )),
                Flexible(
                    flex: 1,
                    child: Text(
                      "${firstToUpperCaseString(e.name)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 10),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  NestedScrollView nestedScrollView() {
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Icon(
                Icons.menu,
              ),
              centerTitle: true,
              pinned: true,
              collapsedHeight: 120,
              title: Text(
                "Beru",
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.shopping_cart,
                  ),
                )
              ],
              // expandedHeight: 120,
              flexibleSpace: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20
                  ),
                  child: SizedBox(
                    height: 30,
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4.0),
                      elevation: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          'search'
                              .text
                              .textStyle(Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal))
                              .make()
                              .pOnly(left: 10),
                          Icon(
                            Icons.search,
                            color: Theme.of(context).iconTheme.color,
                          ).pOnly(right: 10)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: Carousel(
                  images: [
                    NetworkImage(
                        'https://media.gettyimages.com/photos/colorful-fresh-organic-vegetables-picture-id882314812'),
                    NetworkImage(
                        'https://previews.123rf.com/images/puhhha/puhhha1805/puhhha180500313/100520940-healthy-food-fresh-organic-vegetables-on-white-wooden-background-high-resolution.jpg'),
                    NetworkImage(
                        'https://previews.123rf.com/images/puhhha/puhhha1805/puhhha180500313/100520940-healthy-food-fresh-organic-vegetables-on-white-wooden-background-high-resolution.jpg'),
                    NetworkImage(
                        'https://media.gettyimages.com/photos/colorful-fresh-organic-vegetables-picture-id882314812')
                  ],
                  dotSize: 4.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.lightGreenAccent,
                  indicatorBgPadding: 2.0,
                  dotBgColor: Colors.transparent,
                  //borderRadius: true,
                  moveIndicatorFromBottom: 180.0,
                  noRadiusForIndicator: true,
                ),
              ),
            ),
            SliverPadding(
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shop by category',
                        style: Theme.of(context).textTheme.bodyText1),
                    Text('View all',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 8, fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            )
          ];
        },
        body: getCategory(context));
  }
}
