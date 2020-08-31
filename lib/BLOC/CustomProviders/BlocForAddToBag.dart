import 'package:beru/BLOC/CustomeStream/CartStream.dart';
import 'package:beru/CustomException/BeruException.dart';
import 'package:beru/Schemas/Cart.dart';
import 'package:beru/Server/ServerApi.dart';
import 'package:beru/UI/CommonFunctions/BeruAlertWithCallBack.dart';
import 'package:beru/UI/CommonFunctions/BeruLodingBar.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BlocForAddToBag extends ChangeNotifier {
  CartData _cartData;
  List<Cart> _addToBag = [];
  bool hasUpdated = false;

  updateCart(CartData data) => _cartData = data;

  void addToBag(
      Cart cart, BuildContext context, TextEditingController controller) {
    if (_addToBag.isEmpty && cart.count != 0) {
      checkIsExistInCart(cart, context,controller);
      // print("add to bag from BlocForAddToBag in empty");
    } else if (_addToBag.isNotEmpty) {
      int index = _addToBag.indexWhere(
        (element) =>
            element.product.id == cart.product.id &&
            element.salles.id == cart.salles.id,
      );
      if (index == -1) {
        if (cart.count != 0) {
          checkIsExistInCart(cart, context, controller);
          // print("add to bag from BlocForAddToBag where not exist");
        }
      } else {
        if (cart.count != 0) {
          _addToBag[index].count = cart.count;
          // print("Update to bag from BlocForAddToBag where exist");
        } else {
          _addToBag.removeAt(index);
          // print(
          //     "removed from bag from BlocForAddToBag where Zero ptoduct which exist");
        }
      }
    }
    // print("List BlocForAddToBag is $_addToBag");
    notifyListeners();
  }

  void checkIsExistInCart(
      Cart cart, BuildContext context, TextEditingController controller) async {
    if ((_cartData != null && _cartData?.data != null) ||
        (_cartData != null &&
            _cartData.hasError &&
            _cartData.error is BeruNoProductForSalles)) {
      // bool isUpdate = false;
      var data = _cartData?.data?.firstWhere(
        (element) =>
            (element.product.id == cart.product.id) &&
            (element.salles.id == cart.salles.id),
        orElse: () => null,
      );
      if (data == null) {
        _addToBag.add(cart);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Already In Cart Need to update?"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  onPressed: () {
                    controller.text = "0";
                    context.pop();
                    notifyListeners();
                  },
                  child: Text("Cancel"),
                ),
                RaisedButton(
                  onPressed: () {
                    cart.id = data.id;
                    _addToBag.add(cart);
                    print("Data for update ${cart.toMapCreate()}");
                    notifyListeners();
                    context.pop();
                  },
                  child: Text("Update"),
                )
              ],
            ),
          ),
        );
      }
    }
  }

  int getNumberOfiteams() => _addToBag.length;
  bool toBuildAddToBag() => _addToBag.isNotEmpty;

  double totalAmount() {
    try {
      double total = 0;
      for (var i in _addToBag) {
        total = total + (i.count * i.product.amount);
      }
      return total;
    } catch (e) {
      // print("error from totalAmount blocAddTobag $e");
      return 0;
    }
  }

  List<double> toWeightKg() {
    try {
      double totalKg = 0;
      double totalPieace = 0;
      for (var i in _addToBag) {
        if (i.product.inKg) {
          totalKg = totalKg + i.count;
        } else {
          totalPieace = totalPieace + i.count;
        }
      }
      return [totalKg, totalPieace];
    } catch (e) {
      // print("error from toWeigh blocAddTobag $e");
      return [0, 0];
    }
  }

  double getCountIfExist(Cart cart) {
    var data = _addToBag.firstWhere(
      (element) =>
          element.product.id == cart.product.id &&
          element.salles.id == cart.salles.id,
      orElse: () => null,
    );
    // print(" getCountIfExist ${data?.count}");
    return data?.count ?? 0;
  }

  void addToBagInServer(BuildContext context) async {
    showDialog(context: context, child: beruLoadingBar());
    try {
      var res = await ServerApi.addMultiProductToCart(_addToBag);
      print("data from multiCart $res");
      List errors = res['error'] ?? [];
      print("error from multiCart ${errors.length}");
      if (errors.length == 0) {
        context.pop();
        alertWithCallBack(
            cakllback: () {
              _addToBag = [];
              print("is all iteams removed $_addToBag");
              notifyListeners();
              context.pop();
            },
            callBackName: "Back",
            content:
                "${res['added'] == 0 ? "" : res['added'].toString() + ' Items Added To Bag'} ${res['updated'] == 0 ? "" : res['updated'].toString() + ' Iteams Updated in Bag'}",
            context: context);
      } else {
        errors = errors.map((e) {
          return {
            "product": _addToBag
                .firstWhere(
                  (element) {
                    var temp = Cart.fromMap(e['cart']);
                    return (element.product.id == temp.product.id) &&
                        (element.salles.id == temp.salles.id);
                  },
                  orElse: () => null,
                )
                ?.product
                ?.name,
            "error": e['error']
          };
        }).toList();
        context.pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                            "${res['added'] == null ? null : res['added'] + 'Items Added To Bag'.toString()} ${res['updated'] == null ? null : res['updated'].toString() + 'Iteams Updated in Bag'}"),
                        ...errors
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child:
                                      Text("${e['error']} on ${e['product']}"),
                                ))
                            .toList(),
                        Row(
                          children: [
                            RaisedButton(
                              onPressed: () {
                                _addToBag = [];
                                print("is all iteams removed $_addToBag");
                                notifyListeners();
                                context.pop();
                              },
                              child: Text("Back"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      context.pop();
      print(" Error form addToBagInServer ${e.toString()}");
      errorAlert(context, e.toString());
    }
    // var temp = _addToBag.map((e) => e.toMapCreate()).toString();
  }

  void singleIteamToBag(Cart cart, bool withPay, BuildContext context) async {
    var res = "";
    try {
      showDialog(context: context, child: beruLoadingBar());
      int index = _addToBag.indexWhere((element) =>
          (element.product.id == cart.product.id) &&
          (element.salles.id == cart.salles.id));

      if (index == -1) {
        res = "Count Not To Be Zero";
      } else {
        if (withPay) {
          _addToBag[index].paymentComplete = true;
        }
        // print("Data to send server ${_addToBag[index].toString()}");
        res = await ServerApi.addSingleIteamToBag(_addToBag[index]);
        res = res.toString() +
            "${withPay ? " Check In Orders" : " Check In Bag"}";
      }
      context.pop();
      alertWithCallBack(
          cakllback: () {
            if (res != "Count Not To Be Zero") {
              _addToBag.removeAt(index);
            }
            notifyListeners();
            context.pop();
          },
          callBackName: "back",
          content: res,
          context: context);
    } catch (e) {
      context.pop();
      print("Error from in singleIteamToBag ${e.toString()}");
      errorAlert(context, e.toString());
    }
  }
}
