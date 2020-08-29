import 'package:beru/Schemas/BeruUser.dart';

class Salles {
  String _id;
  BeruUser seller;
  BeruUser farmer;
  double count;
  bool toShow;

  String get id {
    return this._id;
  }

  Salles();

  Salles.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id'] ?? null;
    if (temp['farmer_id'] is Map) {
      this.farmer = BeruUser.fromMap(temp['farmer_id']);
    } else if (temp['farmer_id'] is String) {
      this.farmer = BeruUser.fromMap({'_id': temp['farmer_id']});
    }
    if (temp['seller_id'] is Map) {
      this.seller = BeruUser.fromMap(temp['seller_id']);
    } else if (temp['seller_id'] is String) {
      this.seller = BeruUser.fromMap({'_id': temp['seller_id']});
    }
    this.count =
        temp['count'] == null ? null : double.parse(temp['count'].toString());
    this.toShow = temp['toShow'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      'farmer_id': farmer.toMap(),
      'seller_id': seller.toMap(),
      'count': count,
    };
  }

  Map<String, dynamic> toMapCreate() {
    return {
      'farmer_id': farmer?.id ?? null,
      'seller_id': seller?.id ?? null,
      'count': count ?? null,
    };
  }

  static List<Salles> fromMapToListOfSalles(List<dynamic> data) {
    return data.map((e) => Salles.fromMap(e)).toList();
  }
}
