import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/BLOC/CustomeStream/ProductStream.dart';
import 'package:beru/CustomFunctions/BeruString.dart';
import 'package:beru/Responsive/CustomRatio.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Home/BeruBottomNavigator.dart';
import 'package:beru/UI/InterNetConectivity/CheckConnectivity.dart';
import 'package:beru/UI/Product/ShowProduct.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruHome extends StatefulWidget {
  static const String route = '/BeruHome';
  @override
  _BeruHomeState createState() => _BeruHomeState();
}

class _BeruHomeState extends State<BeruHome> with TickerProviderStateMixin {
  int index = 0;
  List<ProductSallesStream> streams = [];
  @override
  Widget build(BuildContext context) {
    return checkInterNet(body(context));
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
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: value.data.list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isMobile ? 2 : 6,
                crossAxisSpacing: 20,
                childAspectRatio: 1.2,
                mainAxisSpacing: 20),
            itemBuilder: (context, index) =>
                showCategory(value.data.list[index], context),
          );
        }
      },
    );
  }

  showCategory(BeruCategory e, BuildContext context) {
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
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      style: Theme.of(context).textTheme.subtitle1,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  body(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BeruBottomNavigator(), body: nestedScrollView());
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
              title: Text("Beru"),
            ),
            SliverToBoxAdapter(
              child: SizedBox.fromSize(
                size: Size.fromHeight(ResponsiveRatio.getHight(10, context)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: context.isMobile ? 0 : 20),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: context.isMobile ? 2.8 : 9,
                      viewportFraction: context.isMobile ? 0.85 : 0.35,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: context.isMobile ? true : false,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [1, 2, 3, 4, 5].map(
                      (i) {
                        return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: context.isMobile ? 0 : 20),
                            elevation: 5,
                            color: Colors.blueAccent,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  'text $i',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ));
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox.fromSize(
                size: Size.fromHeight(ResponsiveRatio.getHight(20, context)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Shop by Catagory",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ];
        },
        body: getCategory(context));
  }

  @override
  void dispose() {
    streams.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}


