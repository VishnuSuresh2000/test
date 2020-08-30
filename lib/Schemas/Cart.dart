import 'package:beru/Schemas/BeruUser.dart';
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

extension ProgressStrings on ProgressOnCart {
  String get string {
    switch (this) {
      case ProgressOnCart.onProgress:
        return "onProgress";
        break;
      case ProgressOnCart.packed:
        return "packed";
        break;
      case ProgressOnCart.onDelivary:
        return "onDelivary";
        break;
      case ProgressOnCart.notDefined:
        return "notDefined";
        break;
    }
    return null;
  }
}

class ProgressNote {
  String _id;
  ProgressOnCart progress;
  DateTime date;
  String message;
  ProgressNote();
  ProgressNote.fromMap(Map<String, dynamic> data) {
    this._id = data['_id'] ?? null;
    this.date = data['date'] != null ? DateTime.parse(data['date']) : null;
    this.progress =
        data['progress'] != null ? progressFromString(data['progress']) : null;
    this.message = data['message'] ?? null;
  }
  String get id => this._id;

  Map<String, dynamic> toMap() {
    return {'progress': this.progress.string, 'message': this.message};
  }

  static List<ProgressNote> fromMapToListOfSalles(List<dynamic> data) {
    return data.map((e) => ProgressNote.fromMap(e)).toList();
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
  DateTime dataOfDalivary;
  double totalAmount;
  DateTime dataOfPayment;
  bool cancel;
  List<ProgressNote> progressNotes;
  BeruUser customer;

  String get id => this._id;
  set id(id) => this._id = id;

  Cart();
  Map<String, dynamic> toMapCreate() {
    return {
      'product_id': product.id,
      'salles_id': salles.id,
      'count': count,
      if (_id != null) '_id': _id,
    };
  }

  Cart.fromMap(Map<String, dynamic> data) {
    // print("Data From Server $data");
    this.progressNotes = data['progressNotes'] != null
        ? ProgressNote.fromMapToListOfSalles(data['progressNotes'])
        : null;

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
    this.dataOfDalivary = data['dataOfDalivary'] == null
        ? null
        : DateTime.parse(data['dataOfDalivary']);
    this.count =
        data['count'] != null ? double.parse(data['count'].toString()) : null;
    this.cancel = data['cancel'] ?? null;
    this.totalAmount = data['totalAmount'] != null
        ? double.parse(data['totalAmount'].toString())
        : null;

    this.progress =
        data['progress'] != null ? progressFromString(data['progress']) : null;
    // if (data['customer_id'] is String) {
    //   this.customer = BeruUser.fromMap({'_id': data['customer_id']});
    // } else if (data['customer_id'] is Map) {
    //   this.customer = BeruUser.fromMap(data['customer_id']);
    // }
  }
}
