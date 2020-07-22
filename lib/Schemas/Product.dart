import 'package:beru/Schemas/BeruCategory.dart';

class Product {
  String name;
  String description;
  String _id;
  bool inKg;
  BeruCategory category;
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
    this.category = BeruCategory.fromMap(temp['category']);
    this.inKg = temp['inKg'];
  }

  String get id {
    return this._id;
  }
}