import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Salles.dart';

class Product {
  String name2;
  String name;
  String description;
  String description2;
  String _id;
  bool inKg;
  BeruCategory category;
  int amount;
  bool hasImg;
  int gstIn;
  List<Salles> salles;
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      'category': category.toMap(),
      'inKg': inKg,
      'amount': amount,
      if (this.name2 != null) 'name2': name2,
      'gstIn': gstIn,
      if (this.description2 != null) 'description2': description2
    };
  }

  Product();

  Product.fromMap(Map<String, dynamic> temp) {
    this.hasImg = temp['hasImg'] ?? false;
    this._id = temp['_id'] ?? null;
    this.name = temp['name'] ?? null;
    this.name2 = temp['name2'] ?? null;
    this.description = temp['description'] ?? null;
    this.description2 = temp['description2'] ?? null;
    if (temp['category'] is String) {
      this.category = BeruCategory.fromMap({"_id": temp['category']});
    } else if (temp['category'] is Map) {
      this.category = BeruCategory.fromMap(temp['category']);
    }
    this.inKg = temp['inKg'] ?? null;
    this.salles = temp['salles'] == null
        ? null
        : Salles.fromMapToListOfSalles(temp['salles']);
    this.amount = temp['amount'] ?? null;
    this.gstIn = temp['gstIn'] ?? 0;
  }

  String get id {
    return this._id;
  }

  set id(String id) {
    this._id = id;
  }
}