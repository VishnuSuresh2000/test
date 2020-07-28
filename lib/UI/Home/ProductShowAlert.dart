import 'package:beru/Responsive/CustomRatio.dart';
import 'package:beru/Schemas/Product.dart';
import 'package:beru/Schemas/Salles.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:flutter/material.dart';
import 'BeruHome.dart';

class ProductShowAlert extends StatefulWidget {
  final Salles sallesProduct;
  final Product product;

  const ProductShowAlert({Key key, this.sallesProduct, this.product})
      : super(key: key);

  @override
  _ProductShowAlertState createState() => _ProductShowAlertState();
}

class _ProductShowAlertState extends State<ProductShowAlert> {
  double value = 0;
  bool showTextFiled = false;
  final _key = GlobalKey<FormState>();
  Salles temp;
  @override
  void initState() {
    temp = widget.sallesProduct;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: ResponsiveRatio.getHight(500, context),
        child: Column(
          children: [
            ...showProucts(widget.product, context),
            if (widget.product.inKg != null)
              Text(
                  "Avaialble : ${temp.count} ${widget.product.inKg ? 'kg' : 'piece'}")
            else
              Text("No Quantity Specified"),
            Padding(
              padding: EdgeInsets.all(ResponsiveRatio.getHight(10, context)),
              child: Container(
                color: Color(0xffebebeb),
                height: 2.0,
              ),
            ),
            if (widget.product.inKg != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (value > 0)
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            showTextFiled = false;
                            value = value - 0.5;
                          });
                        })
                  else
                    Container(
                      width: 50,
                    ),
                  Container(
                    height: 30,
                    width: 60,
                    child: Stack(
                      children: [
                        if (!showTextFiled)
                          InkWell(
                            onTap: () {
                              showTextFiled = true;
                              setState(() {});
                            },
                            child: Center(
                              child: Text(
                                  "$value ${widget.product.inKg ? 'kg' : 'piece'}"),
                            ),
                          ),
                        if (showTextFiled)
                          Form(
                            key: _key,
                            child: TextFormField(
                              initialValue: value.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                errorStyle:
                                    Theme.of(context).textTheme.subtitle2,
                              ),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  try {
                                    double temp2 = double.parse(value);
                                    if (temp2 > temp.count) {
                                      errorAlert(context,
                                          "Must be less than Avaialble");
                                      return null;
                                    }
                                    return null;
                                  } catch (e) {
                                    return "Must be Number";
                                  }
                                }
                                return null;
                              },
                              onSaved: (valu) {
                                double temp2 = double.parse(valu);
                                if (temp2 <= temp.count) {
                                  value = temp2;
                                }
                              },
                              onFieldSubmitted: (value) {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                  setState(() {
                                    showTextFiled = false;
                                  });
                                }
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                  if (value < temp.count)
                    IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            showTextFiled = false;
                            value = value + 0.5;
                          });
                        })
                  else
                    Container(
                      width: 50,
                    ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Farmer :", style: Theme.of(context).textTheme.headline1),
                DropdownButton(
                    style: Theme.of(context).textTheme.subtitle2,
                    value: temp,
                    hint: Text("Farmers :"),
                    items: widget.product.salles
                        .map((e) => DropdownMenuItem<Salles>(
                            value: e,
                            child: Text(
                              "${e.farmer.fullName}",
                              key: ValueKey(e.farmer.id),
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        temp = value;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Seller :", style: Theme.of(context).textTheme.headline1),
                Text("${widget.sallesProduct.seller.fullName}",
                    style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
            SizedBox.fromSize(
              size: Size.fromHeight(20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                      style: Theme.of(context).textTheme.subtitle1),
                  elevation: 0,
                ),
                if (widget.product.inKg != null)
                  RaisedButton(
                    onPressed: () {},
                    elevation: 0,
                    child: Text("Cart",
                        style: Theme.of(context).textTheme.subtitle2),
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
