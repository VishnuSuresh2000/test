import 'package:beru/Schemas/Cart.dart';
import 'package:beru/UI/CommonFunctions/ErrorAlert.dart';
import 'package:flutter/material.dart';

class BlocForAddToBag extends ChangeNotifier {
  List<Cart> _addToBag = [];
  bool hasUpdated = false;

  void addToBag(Cart cart) {
    if (_addToBag.isEmpty && cart.count != 0) {
      _addToBag.add(cart);
      // print("add to bag from BlocForAddToBag in empty");
    } else if (_addToBag.isNotEmpty) {
      int index = _addToBag.indexWhere(
        (element) =>
            element.product.id == cart.product.id &&
            element.salles.id == cart.salles.id,
      );
      if (index == -1) {
        if (cart.count != 0) {
          _addToBag.add(cart);
          // print("add to bag from BlocForAddToBag where not exist");
        }
      } else {
        if (cart.count != 0) {
          _addToBag[index] = cart;
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

  void test(BuildContext context) {
    var temp = _addToBag.map((e) => e.toMapCreate()).toString();
    print("Data in _addToBag ${temp.toString()}");
    errorAlert(context, "On Working Function Not Available");
  }
}
