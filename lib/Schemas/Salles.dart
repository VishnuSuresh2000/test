import 'package:beru/Schemas/user.dart';

class Salles {
  String _id;
  User seller;
  User farmer;
  int count;
  int amount;

  String get id {
    return this._id;
  }

  Salles();

  Salles.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id'];
    this.farmer =
        temp['farmer_id'] == null ? null : User.fromMapTest(temp['farmer_id']);
    this.seller =
        temp['seller_id'] == null ? null : User.fromMapTest(temp['seller_id']);
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

  static List<Salles> fromMapToListOfSalles(List<dynamic> data) {
    return data.map((e) => Salles.fromMap(e)).toList();
  }
}
