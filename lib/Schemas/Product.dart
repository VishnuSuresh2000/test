import 'package:beru/Schemas/BeruCategory.dart';
import 'package:beru/Schemas/Salles.dart';

class Product {
  String name;
  String description;
  String _id;
  bool inKg;
  BeruCategory category;
  List<Salles> salles;
  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      "name": name,
      "description": description,
      'category': category.toMap(),
      'inKg': inKg
    };
  }

  Product();

  Product.fromMap(Map<String, dynamic> temp) {
    this._id = temp['_id'];
    this.name = temp['name'];
    this.description = temp['description'];
    this.category = temp['category'] is String
        ? BeruCategory.fromMap({"_id": temp['category']})
        : BeruCategory.fromMap(temp['category']);
    this.inKg = temp['inKg'];
    this.salles = temp['salles'] == null
        ? null
        : Salles.fromMapToListOfSalles(temp['salles']);
  }

  String get id {
    return this._id;
  }

  set id(String id) {
    this._id = id;
  }
}
