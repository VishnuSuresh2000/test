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
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:beru/UI/Home/BeruSerach.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: "Beru Community".text.make(),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.shopping_cart,
                    ),
                  )
                ],
                expandedHeight: 150,
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          Selector<BlocForAddToBag,
                  Tuple5<Function, Function, Function, Function, Function>>(
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
                  handler.test))
        ],
      ),
    );
  }

  Align bottomBarAddToCart(double totalAmount, List<double> weight,
      int noOfIteams, Function callBack, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
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
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16))
                      .make()
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showProduct(Product product) {
    var update =
        context.select<BlocForAddToBag, Function>((value) => value.addToBag);
    Cart cart = Cart();
    cart.product = product;
    cart.salles = product.salles[0];
    TextEditingController _controller = TextEditingController();
    _controller.text = context.select<BlocForAddToBag, String>(
        (value) => value.getCountIfExist(cart).toString());
    _controller.addListener(() {
      if (mounted) {
        if (_controller.text.isNotEmpty) {
          try {
            var temp = double.parse(_controller.text);
            if (temp < 0) {
              errorAlert(context, "Must be Grater thean zero");
              _controller.text = "0";
            } else if (temp > product.salles[0].count) {
              errorAlert(context, "Must be less than Available");
              _controller.text = "${product.salles[0].count}";
            }
          } catch (e) {
            errorAlert(context, "Must be Number");
            _controller.text = "0";
          } finally {
            cart.count = double.parse(_controller.text);
            update(cart);
          }
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
                  "${product.salles[0]?.count} ${product.inKg ? 'Kg' : 'Pieces'}   \₹ ${product.amount}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 14),
                )),
            Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: ChangeNotifierProvider(
                    create: (context) => ValueNotifier<bool>(true),
                    child: Consumer<ValueNotifier<bool>>(
                      builder: (context, value, child) {
                        return Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        size: 10,
                                      ),
                                      onPressed: () {
                                        double comput =
                                            double.parse(_controller.text) -
                                                (product.inKg ? 0.25 : 1);
                                        if (comput >= 0) {
                                          _controller.text = "$comput";
                                        }
                                      })),
                              Flexible(
                                flex: 2,
                                child: Container(
                                  color: Color(0xff68D8AE),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        counter: Offstage(),
                                        isCollapsed: true,
                                        prefix: Offstage(),
                                        border: InputBorder.none,
                                      ),
                                      controller: _controller,
                                      readOnly: value.value,
                                      keyboardType: TextInputType.number,
                                      maxLength: 2,
                                      onSubmitted: (data) {
                                        if (_controller.text.isEmpty) {
                                          _controller.text = "0";
                                        }
                                        print("on completed");
                                        value.value = (!value.value);
                                      },
                                      onTap: () {
                                        print("on completed tap");
                                        if (value.value) {
                                          value.value = (!value.value);
                                          print("value ${value.value}");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                  child: IconButton(
                                      icon: Icon(Icons.add, size: 10),
                                      onPressed: () {
                                        double comput =
                                            double.parse(_controller.text) +
                                                (product.inKg ? 0.25 : 1);
                                        if (comput <= product.salles[0].count) {
                                          _controller.text = "$comput";
                                        }
                                      }))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )),
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart,
                            size: 10,
                          ),
                          10.widthBox,
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
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 10,
                            color: Color(0xff2BC48A),
                          ),
                          10.widthBox,
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
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
