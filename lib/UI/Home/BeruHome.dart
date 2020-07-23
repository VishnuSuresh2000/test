import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomeStream/ProductStream.dart';
import 'package:beru/Responsive/CustomRatio.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Schemas/Salles.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
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
    List<Stream<List<Product>>> streams = [];
    return Scaffold(
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
                  color: Color(0xff545d68),
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
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
      body: tabBarViewHome(items, streams, tabController),
    ));
  }

  TabBarView tabBarViewHome(List<BeruCategory> items,
      List<Stream<List<Product>>> streams, TabController tabController) {
    return TabBarView(
      children: items.map((e) {
        var stream = ProductSallesStream(category: e).stream;
        streams.add(stream);
        return ShowProductOnSalles(
          stream: stream,
        );
      }).toList(),
      controller: tabController,
    );
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
            Container(
              height: ResponsiveRatio.getHight(75, context),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/apple.jpg",
                    ),
                    fit: BoxFit.contain),
              ),
            ),
            Text(
              "\₹ ${product.salles[select].amount}",
              style: TextStyle(
                color: Color(0xffcc8053),
                fontFamily: 'SourceSansPro',
                fontSize: 18.0,
              ),
            ),
            Text(
              "${product.name}",
              style: TextStyle(
                color: Colors.green,
                fontFamily: 'SourceSansPro',
                fontSize: 20.0,
              ),
            ),
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
              color: Colors.white,
              child: Text("Buy Now",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'SourceSansPro',
                    fontSize: 20.0,
                  )),
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

class ProductShowAlert extends StatefulWidget {
  ProductShowAlert({
    Key key,
    this.sallesProduct,
    this.product,
  }) : super(key: key);

  Salles sallesProduct;
  Product product;

  @override
  _ProductShowAlertState createState() => _ProductShowAlertState();
}

class _ProductShowAlertState extends State<ProductShowAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: ResponsiveRatio.getHight(340, context),
        child: Column(
          children: [
            Container(
              height: ResponsiveRatio.getHight(75, context),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(
                      "assets/images/apple.jpg",
                    ),
                    fit: BoxFit.contain),
              ),
            ),
            Text(
              "\₹ ${widget.sallesProduct.amount}",
              style: TextStyle(
                color: Color(0xffcc8053),
                fontFamily: 'SourceSansPro',
                fontSize: 18.0,
              ),
            ),
            Text(
              "${widget.product.name}",
              style: TextStyle(
                color: Colors.green,
                fontFamily: 'SourceSansPro',
                fontSize: 20.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveRatio.getHight(10, context)),
              child: Container(
                color: Color(0xffebebeb),
                height: 2.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seller :",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    )),
                DropdownButton(
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    ),
                    value: widget.sallesProduct,
                    hint: Text("Sallers"),
                    items: widget.product.salles
                        .map((e) => DropdownMenuItem<Salles>(
                            value: e, child: Text("${e.seller.fullName}")))
                        .toList(),
                    onChanged: (value) {
                      widget.sallesProduct = value;
                      setState(() {});
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("Farmer :",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    )),
                    Text("${widget.sallesProduct.farmer.fullName}",
                    style: TextStyle(
                      color: Colors.green,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    )),
            ],),
            SizedBox.fromSize(
              size: Size.fromHeight(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: 'SourceSansPro',
                        fontSize: 20.0,
                      )),
                  elevation: 0,
                  color: Colors.white,
                ),
                RaisedButton(
                  onPressed: () {},
                  elevation: 0,
                  color: Colors.white,
                  child: Text("Cart",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontFamily: 'SourceSansPro',
                        fontSize: 20.0,
                      )),
                ),
              ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
