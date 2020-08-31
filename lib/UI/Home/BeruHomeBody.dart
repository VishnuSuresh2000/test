import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Product/ShowProduct.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruHomeBody extends StatefulWidget {
  @override
  _BeruHomeBodyState createState() => _BeruHomeBodyState();
}

class _BeruHomeBodyState extends State<BeruHomeBody> {
  @override
  Widget build(BuildContext context) {
    return nestedScrollView();
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
            crossAxisCount: context.isMobile ? 2 : 6,
            primary: false,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15.0,
            childAspectRatio: 1.3,
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
                    fit: FlexFit.tight,
                    flex: 3,
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
                      "${e.name.toUpperCase()}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 10, letterSpacing: 1),
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
            SliverPadding(
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: SizedBox(
                    width: double.infinity,
                    height: 120,
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
                      dotPosition: DotPosition.bottomCenter,
                      showIndicator: true,
                      moveIndicatorFromBottom: 180.0,
                      noRadiusForIndicator: true,
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5),
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
