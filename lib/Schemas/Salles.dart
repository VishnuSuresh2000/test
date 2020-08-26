import 'package:beru/Schemas/BeruUser.dart';

class Salles {
  String _id;
  BeruUser seller;
  BeruUser farmer;
  double count;
  

  String get id {
    return this._id;
  }

  Salles();

  Salles.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id']??null;
    this.farmer =
        temp['farmer_id'] == null ? null : BeruUser.fromMapTest(temp['farmer_id']);
    this.seller =
        temp['seller_id'] == null ? null : BeruUser.fromMapTest(temp['seller_id']);
    this.count = double.parse(temp['count']);
    
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'farmer_id': farmer.toMap(),
      'seller_id': seller.toMap(),
      'count': count,
      
    };
  }

  static List<Salles> fromMapToListOfSalles(List<dynamic> data) {
    return data.map((e) => Salles.fromMap(e)).toList();
  }
}
