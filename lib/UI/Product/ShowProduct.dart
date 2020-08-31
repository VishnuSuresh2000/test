import 'package:beru/BLOC/CustomProviders/BLOCForCategory.dart';
import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/BLOC/CustomProviders/BlocForAddToBag.dart';
import 'package:beru/BLOC/CustomeStream/ProductStream.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Cart.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Home/BeruSerach.dart';
import 'package:beru/UI/Home/ShowCartButton.dart';
import 'package:beru/UI/Product/Counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowProducts extends StatefulWidget {
  static const String route = "/showProduct";
  @override
  _ShowProductsState createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts>
    with SingleTickerProviderStateMixin {
  BeruCategory category;
  TabController _tabController;
  BlocForCategory blocForCategory;
  final _scafoldKey = GlobalKey<ScaffoldState>();
  bool _isSnackbarActive = false;
  @override
  void initState() {
    blocForCategory = context.read<BlocForCategory>() ?? null;
    category = (context.read<BloCForHome>()).category ?? null;
    _tabController = TabController(
        length: blocForCategory?.data?.list?.length ?? 0, vsync: this);
    super.initState();
    _tabController.addListener(() {
      category = blocForCategory?.data?.list[_tabController.index] ?? null;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> _showProduct = [];
    var products = context.watch<SallesData>() ?? null;
    if (category != null) {
      products?.data?.forEach((element) {
        if (element.category.id == category.id) {
          _showProduct.add(element);
        }
      });
      _tabController.index = blocForCategory?.data?.list
              ?.indexWhere((element) => element.id == category.id) ??
          -1 + 1;
    }
    return Scaffold(
      key: _scafoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: "Beru Community".text.make(),
                actions: [ShowCartButton()],
                collapsedHeight: 100,
                // expandedHeight: 150,
                flexibleSpace: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                            .add(EdgeInsets.only(bottom: 35)),
                    child: BeruSearchBar(),
                  ),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: blocForCategory.data.list
                        .map((e) => Tab(
                              child: e.name.firstLetterUpperCase().text.make(),
                            ))
                        .toList()),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20
                  ),
                  child: Divider(
                    color: Color(0xff707070),
                    thickness: 0.3,
                  ),
                ),
              ),
              if (products?.hasError == null && products?.data == null)
                SliverToBoxAdapter(
                  child: beruLoadingBar(),
                ),
              if (products?.hasError != null &&
                  products.hasError &&
                  products?.error != null)
                SliverToBoxAdapter(
                  child: BeruErrorPage(
                    errMsg: products.error.toString(),
                  ),
                ),
              if (products?.hasError != null &&
                  !products.hasError &&
                  products?.data != null)
                if (_showProduct.isEmpty)
                  SliverToBoxAdapter(
                    child: BeruErrorPage(
                      errMsg: BeruNoProductForSalles().toString(),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                        .add(EdgeInsets.only(
                            bottom: context.select<BlocForAddToBag, bool>(
                                    (value) => value.toBuildAddToBag())
                                ? 70
                                : 0)),
                    sliver: SliverGrid.count(
                      crossAxisCount: context.isMobile ? 2 : 6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                      children:
                          _showProduct.map((e) => showProduct(e)).toList(),
                    ),
                  )
            ],
          ),
          Selector<
                  BlocForAddToBag,
                  Tuple5<
                      bool Function(),
                      int Function(),
                      List<double> Function(),
                      double Function(),
                      void Function(BuildContext)>>(
              shouldRebuild: (previous, next) => true,
              builder: (context, value, child) {
                if (value.item1()) {
                  return bottomBarAddToCart(value.item4(), value.item3(),
                      value.item2(), value.item5, context);
                } else {
                  return Offstage();
                }
              },
              selector: (_, handler) => Tuple5(
                  handler.toBuildAddToBag,
                  handler.getNumberOfiteams,
                  handler.toWeightKg,
                  handler.totalAmount,
                  handler.addToBagInServer))
        ],
      ),
    );
  }

  showSnackBarOnPage(String content) {
    if (mounted) {
      _isSnackbarActive = true;
      _scafoldKey.currentState
          .showSnackBar(SnackBar(
              behavior: SnackBarBehavior.fixed,
              // margin: EdgeInsets.symmetric(
              // vertical: 10
              // ),
              backgroundColor: Color(0xff2BC48A),
              content: SizedBox(
                // height: 40,
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              )))
          .closed
          .then((value) {
        setState(() {
          _isSnackbarActive = false;
        });
      });
    }
  }

  Align bottomBarAddToCart(double totalAmount, List<double> weight,
      int noOfIteams, Function callBack, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: _isSnackbarActive ? 40 : 0),
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: SizedBox(
            height: 70,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      "$noOfIteams ITEMS   ${weight[0]} KG , ${weight[1]} PIECE"
                          .text
                          .textStyle(Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 10, color: Color(0xff979797)))
                          .make(),
                      "\₹$totalAmount"
                          .text
                          .textStyle(Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                          .make()
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: Color(0xff2BC48A),
                        onPressed: () => callBack(context),
                        child: SizedBox(
                          width: 150,
                          child: "Add To Bag"
                              .text
                              .textStyle(Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500))
                              .make()
                              .centered(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showProduct(Product product) {
    var update = context.select<
        BlocForAddToBag,
        void Function(Cart, BuildContext,
            TextEditingController)>((value) => value.addToBag);
    Cart cart = Cart();
    cart.product = product;
    cart.salles = product.salles[0];
    TextEditingController _controller = TextEditingController();
    var updateFunction = context
        .select<BlocForAddToBag, Function>((value) => value.getCountIfExist);
    _controller.text = updateFunction(cart).toString();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        try {
          var temp = double.parse(_controller.text);
          if (temp < 0) {
            showSnackBarOnPage("Must be Grater thean zero");
            _controller.text = "0";
          } else if (temp > product.salles[0].count) {
            showSnackBarOnPage("Maximum Product Selected");
            _controller.text = "${product.salles[0].count}";
          }
        } catch (e) {
          showSnackBarOnPage("Must be Number");
          _controller.text = "0";
        } finally {
          cart.count = double.parse(_controller.text);
          if (mounted) {
            update(cart, context, _controller);
          }
          // _controller.text = updateFunction(cart).toString();
        }
      }
    });
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: product.hasImg
                  ? Image.network(
                      "${ServerApi.url}/product/getImage/${product.id}",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                      print("error from product img $error");
                      return Image.asset(
                        "assets/images/NoImg.png",
                        fit: BoxFit.contain,
                      );
                    })
                  : Image.asset(
                      "assets/images/NoImg.png",
                      fit: BoxFit.contain,
                    ),
            ),
            Flexible(
                flex: 1,
                child: Text(
                  "${product.name?.firstLetterUpperCase()}",
                  style: Theme.of(context).textTheme.bodyText2,
                )),
            Flexible(
                flex: 1,
                child: Text(
                  "\₹ ${product.amount}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 14),
                )),
            Flexible(
                flex: 1,
                child: Counter(
                  controller: _controller,
                  product: product,
                )),
            Flexible(
                flex: 1,
                child: Selector<BlocForAddToBag,
                        void Function(Cart, bool, BuildContext)>(
                    builder: (context, value, child) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xffE3E3E3), width: 0.3))),
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () => value(cart, false, context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Color(0xffE3E3E3),
                                                width: 0.3))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_shopping_cart,
                                          size: 10,
                                        ),
                                        2.widthBox,
                                        Text(
                                          "Add to bag",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Color(0xff979797)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: InkWell(
                                  onTap: () => value(cart, true, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 10,
                                        color: Color(0xff2BC48A),
                                      ),
                                      2.widthBox,
                                      Text("Buy Now",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Color(0xff2BC48A)))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    selector: (_, handler) => handler.singleIteamToBag))
          ],
        ),
      ),
    );
  }
}
