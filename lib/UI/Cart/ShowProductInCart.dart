import 'package:beru/BLOC/CustomProviders/BlocForAddToBag.dart';
import 'package:beru/BLOC/CustomeStream/CartStream.dart';
import 'package:beru/Schemas/Cart.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowProductsInCart extends StatefulWidget {
  static const String route = '/cart';
  @override
  _ShowProductsInCartState createState() => _ShowProductsInCartState();
}

class _ShowProductsInCartState extends State<ShowProductsInCart> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartData>() ?? null;
    print("from show Products ${cart.data}");
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  if (cart == null ||
                      (cart.data == null && cart.hasError == null))
                    beruLoadingBar(),
                  if (cart.hasError)
                    BeruErrorPage(
                      errMsg: cart.error.toString(),
                    ),
                  // if (cart?.data?.isEmpty??true)
                  //   BeruErrorPage(
                  //     errMsg: "No Products are in Cart",
                  //   ),
                  if (!cart.hasError && cart.data.length != 0)
                    ...cart.data.map((e) => showCart(e)).toList()
                  else
                    Container(),
                ])),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              )
            ],
          ),
          Selector<
                  BlocForAddToBag,
                  Tuple4<bool Function(), List<double> Function(),
                      double Function(), void Function(BuildContext)>>(
              builder: (context, value, child) {
                if (value.item1()) {
                  return bottomBarAddToCart(
                      value.item3(), value.item2(), value.item4, context);
                } else {
                  return Offstage();
                }
              },
              selector: (_, handler) => Tuple4(
                  handler.toBuildCardCod,
                  handler.toWeightCart,
                  handler.totalAmountInPay,
                  handler.conformOrdersInCart))
        ],
      ),
    );
  }

  Align bottomBarAddToCart(double totalAmount, List<double> weight,
      Function callBack, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
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
                    "${weight[0]} KG , ${weight[1]} PIECE"
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
                        child: "Pay On Delivary"
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
    );
  }

  Widget showCart(Cart cart) {
    return SizedBox(
      height: 150,
      child: Card(
        color: Color(0xffFBFBFB),
        child: Column(
          children: [
            Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: cart.product.hasImg
                                    ? Image.network(
                                        "${ServerApi.url}/product/getImage/${cart.product.id}",
                                        fit: BoxFit.contain,
                                        height: 90, errorBuilder:
                                            (context, error, stackTrace) {
                                        print("error from product img $error");
                                        return Image.asset(
                                          "assets/images/NoImg.png",
                                          fit: BoxFit.contain,
                                          height: 90,
                                        );
                                      })
                                    : Image.asset(
                                        "assets/images/NoImg.png",
                                        fit: BoxFit.contain,
                                        height: 90,
                                      ),
                              ),
                            ),
                          ),
                          Flexible(
                              child: Center(
                                  child: Text(
                            "Qty : ${cart.count} ${cart.product.inKg ? 'KG' : 'PIECE'}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 7,
                                    ),
                          )))
                        ],
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${cart?.product?.name?.firstLetterUpperCase()}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Sold by : ',
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                                  TextSpan(
                                    text: " ${cart?.salles?.seller?.fullName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            fontWeight: FontWeight.normal),
                                  )
                                ]),
                          ),
                          Text(
                            "\₹${cart?.totalAmount}",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                          ),
                          Text(
                            'Deliverd by ${cart?.dataOfDalivary == null ? "Upto 3 days After Conformation" : formatter.format(cart.dataOfDalivary)}',
                            style: Theme.of(context)
                                .appBarTheme
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 7, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            '* Cash On Delivery only',
                            style: Theme.of(context)
                                .appBarTheme
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 7, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ))
                    ],
                  ),
                )),
            Flexible(
                child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xffE3E3E3), width: 0.3))),
              child: SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () => {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color: Color(0xff25B5B5B), width: 0.3))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 10,
                              ),
                              2.widthBox,
                              Text(
                                "Remove",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Color(0xff25B5B5B)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () => {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 10,
                              color: Color(0xff25B5B5B),
                            ),
                            2.widthBox,
                            Text("Buy Now",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Color(0xff25B5B5B)))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
