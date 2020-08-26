import 'package:beru/BLOC/CustomProviders/BLOCForHome.dart';
import 'package:beru/BLOC/CustomeStream/ProductStream.dart';
import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruErrorPage.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/Product/ProductShowAlert.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';

class ShowProducts extends StatefulWidget {
  static const String route = "/showProduct";
  @override
  _ShowProductsState createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  ProductSallesStream _productSallesStream;
  BeruCategory category = BeruCategory();
  @override
  void initState() {
    super.initState();
    _productSallesStream = ProductSallesStream();
  }

  @override
  Widget build(BuildContext context) {
    category =
        context.select<BloCForHome, BeruCategory>((value) => value.category);
    _productSallesStream.init(category: category);
    return Scaffold(
      appBar: AppBar(
        title: "${category?.name?.firstLetterUpperCase()}".text.make(),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productSallesStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return BeruErrorPage(
              errMsg: snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            return GridView.count(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              crossAxisCount: context.isMobile ? 2 : 6,
              crossAxisSpacing: 20,
              childAspectRatio: 1.0,
              mainAxisSpacing: 20,
              children: snapshot.data.map((e) => showProduct(e)).toList(),
            );
          } else {
            return beruLoadingBar();
          }
        },
      ),
    );
  }

  Widget showProduct(Product product) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 2,
              child: product.hasImg
                  ? Image.network(
                      "${ServerApi.url}/product/getImage/${product.id}",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          "$error".text.bold.make().centered(),
                    )
                  : Image.asset(
                      "assets/images/NoImg.png",
                      fit: BoxFit.contain,
                    ),
            ),
            Flexible(
                flex: 1,
                child: Text(
                  "\₹ ${product.amount}",
                  style: Theme.of(context).textTheme.caption,
                )),
            Flexible(
                flex: 1,
                child: Text(
                  "${product.name?.firstLetterUpperCase()}",
                  style: Theme.of(context).textTheme.subtitle2,
                )),
            Flexible(
                flex: 1,
                child: RaisedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ProductShowAlert(
                      product: product,
                      sallesProduct: product.salles[0],
                    ),
                  ),
                  child: Text("Buy Now",
                      style: Theme.of(context).textTheme.subtitle1),
                  elevation: 0,
                ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
   
    super.dispose();
    _productSallesStream.dispose();
  }
}
