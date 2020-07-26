import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/userProvider.dart';
import 'package:beru/BLOC/CustomeStream/ProductStream.dart';
import 'package:beru/CustomFunctions/BeruString.dart';
import 'package:beru/Responsive/CustomRatio.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Schemas/Salles.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Home/ProductShowAlert.dart';
import 'package:beru/UI/InterNetConectivity/CheckConnectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return checkInterNet(getCategory(context));
  }

  Consumer getCategory(BuildContext context) {
    return Consumer<BlocForCategory>(
      builder: (context, value, child) {
        if (value == null || value.data.loading) {
          return BeruLoadingBar();
        } else if (value.data.isError) {
          return BeruErrorPage(
            errMsg: value.data.error.toString(),
          );
        } else {
          return body(context, value.data.list);
        }
      },
    );
  }

  Scaffold body(BuildContext context, List<BeruCategory> items) {
    TabController tabController;
    try {
      tabController =
          TabController(length: items.length, vsync: this, initialIndex: index);
    } catch (e) {
      print("Error from tab controller init $e");
      tabController =
          TabController(length: items.length, vsync: this, initialIndex: 0);
    }
    tabController.addListener(() {
      index = tabController.index;
    });

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () =>Provider.of<UserState>(context,listen: false).signOut(),
          child: Text("Out"),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: Icon(
                  Icons.menu,
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        right: ResponsiveRatio.getWigth(10, context)),
                    child: Icon(
                      Icons.notifications,
                    ),
                  ),
                ],
                centerTitle: true,
                pinned: true,
                expandedHeight: ResponsiveRatio.getHight(180, context),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.none,
                  titlePadding: EdgeInsets.only(
                      top: ResponsiveRatio.getHight(100, context),
                      bottom: ResponsiveRatio.getHight(60, context),
                      left: ResponsiveRatio.getWigth(20, context)),
                  title: Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                title: Text("Beru"),
                bottom: TabBar(
                    indicatorColor: Colors.transparent,
                    controller: tabController,
                    tabs: items
                        .map((e) => Tab(
                              text: "${e.name.toString().toUpperCase()}",
                            ))
                        .toList()),
              )
            ];
          },
          body: tabBarViewHome(items, tabController),
        ));
  }

  TabBarView tabBarViewHome(
      List<BeruCategory> items, TabController tabController) {
    return TabBarView(
      children: items.map((e) {
        var stream = ProductSallesStream(category: e);
        streams.add(stream);
        return ShowProductOnSalles(
          stream: stream.stream,
        );
      }).toList(),
      controller: tabController,
    );
  }

  @override
  void dispose() {
    streams.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}

class ShowProductOnSalles extends StatelessWidget {
  final Stream<List<Product>> stream;

  const ShowProductOnSalles({Key key, this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildStreamBuilder();
  }

  StreamBuilder<List<Product>> buildStreamBuilder() {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return GridView.count(
            crossAxisCount: 2,
            primary: false,
            crossAxisSpacing: ResponsiveRatio.getWigth(15, context),
            mainAxisSpacing: ResponsiveRatio.getHight(15, context),
            childAspectRatio: .9,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(
                left: ResponsiveRatio.getWigth(15, context),
                right: ResponsiveRatio.getWigth(15, context),
                top: ResponsiveRatio.getHight(10, context)),
            children:
                snapshot.data.map((e) => productView(e, context)).toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget productView(Product product, BuildContext context) {
    int select = 0;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3.0,
              blurRadius: 5.0,
            ),
          ],
          color: Colors.white),
      child: Center(
        child: Column(
          children: [
            SizedBox.fromSize(
              size: Size.fromHeight(ResponsiveRatio.getHight(10, context)),
            ),
            ...showProucts(product, context),
            Padding(
              padding: EdgeInsets.all(ResponsiveRatio.getHight(10, context)),
              child: Container(
                color: Color(0xffebebeb),
                height: 2.0,
              ),
            ),
            RaisedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    Salles sallesProduct = product.salles[select];
                    return ProductShowAlert(
                      sallesProduct: sallesProduct,
                      product: product,
                    );
                  },
                );
              },
              elevation: 0,
              child:
                  Text("Buy Now", style: Theme.of(context).textTheme.subtitle1),
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(ResponsiveRatio.getHight(5, context)),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}

List<Widget> showProucts(Product product, BuildContext context) {
  return [
    Container(
      height: ResponsiveRatio.getHight(75, context),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: product.hasImg
              ? NetworkImage(
                  "${ServerApi.url}/product/getImage/${product.name}")
              : AssetImage('assets/images/NoImg.png'),
        ),
      ),
    ),
    Text(
      "\₹ ${product.amount}",
      style: Theme.of(context).textTheme.caption,
    ),
    Text(
      "${firstToUpperCaseString(product.name)}",
      style: Theme.of(context).textTheme.subtitle2,
    )
  ];
}
