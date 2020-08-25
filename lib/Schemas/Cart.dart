import 'package:beru/Schemas/Product.dart';
import 'package:beru/Schemas/Salles.dart';

enum ProgressOnCart { onProgress, packed, onDelivary, notDefined }

ProgressOnCart progressFromString(String value) {
  switch (value) {
    case "onProgress":
      return ProgressOnCart.onProgress;
      break;
    case "packed":
      return ProgressOnCart.packed;
      break;
    case "onDelivary":
      return ProgressOnCart.onDelivary;
      break;
    default:
      print("Progress is Not defined : $value");
      return ProgressOnCart.notDefined;
  }
}

class Cart {
  ProgressOnCart progress;
  String _id;
  Product product;
  double count;
  Salles salles;
  bool completed;
  bool paymentComplete;
  DateTime dataOfCreation;
  DateTime dataOfCompltion;
  double totalAmount;
  DateTime dataOfPayment;
  bool cancel;

  String get id => this._id;

  Cart();
  Map<String, dynamic> toMapCreate() {
    return {'product_id': product.id, 'salles_id': salles.id, 'count': count};
  }

  Cart.fromMap(Map<String, dynamic> data) {
    this._id = data['_id'] ?? null;
    if (data['product_id'] is String) {
      this.product = Product.fromMap({'_id': data['product_id']});
    } else if (data['product_id'] is Map) {
      this.product = Product.fromMap(data['product_id']);
    }
    if (data['salles_id'] is String) {
      this.salles = Salles.fromMap({'_id': data['salles_id']});
    } else if (data['product_id'] is Map) {
      this.salles = Salles.fromMap(data['salles_id']);
    }
    this.dataOfCreation = data['dataOfCreation'] == null
        ? null
        : DateTime.parse(data['dataOfCreation']);
    this.dataOfCompltion = data['dataOfCompltion'] == null
        ? null
        : DateTime.parse(data['dataOfCompltion']);
    this.dataOfPayment = data['dataOfPayment'] == null
        ? null
        : DateTime.parse(data['dataOfPayment']);
    this.count = data['count'] ?? null;
    this.cancel = data['cancel'] ?? null;
    this.totalAmount = data['totalAmount'] ?? null;
    this.progress =
        data['progress'] != null ? progressFromString(data['progress']) : null;
  }
}
