import 'package:beru/Schemas/user.dart';

class ProductList {
  String _id;
  User seller;
  User farmer;
  int count;
  int amount;

  String get id {
    return this._id;
  }

  ProductList();

  ProductList.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id'];
    this.farmer = temp['farmer_id'] ==null?null:User.fromMapTest(temp['farmer_id']);
    this.seller = temp['seller_id'] ==null?null:User.fromMapTest(temp['seller_id']);
    this.count = temp['count'];
    this.amount = temp['amount'];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'farmer_id': farmer.toMap(),
      'seller_id': seller.toMap(),
      'count': count,
      'amount': amount
    };
  }
}
