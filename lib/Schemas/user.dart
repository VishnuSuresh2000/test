import 'package:beru/Schemas/address.dart';

class User {
  String firstName;
  String lastName;
  int phoneNumber;
  String email;
  Address address;
  String _id;
  bool sex;
  
  String get fullName {
    return "$firstName ${lastName??""}";
  }

  String get id {
    return _id;
  }

  set id(String id) {
    this._id = id;
  }

  User();
  User.fromMap(Map<String, dynamic> data) {
    this.firstName = data['firstName'] ?? null;
    this.lastName = data['lastName'] ?? null;
    this.phoneNumber = data['phoneNumber'] ?? null;
    this.sex = data['sex'] ?? null;
    this.address =
        data['address'] == null ? null : Address.fromMap(data['address']);
    this.email = data['email']??null;
  }
  User.fromMapTest(Map<String, dynamic> data) {
    this.firstName = data['name'] ?? null;
    this.lastName = data['lastName'] ?? null;
    this.phoneNumber = data['phoneNumber'] ?? null;
    this.sex = data['sex'] ?? null;
    this.address =
        data['address'] == null ? null : Address.fromMap(data['address']);
    this.email = data['email']??null;
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': this.firstName??null,
      'lastName': this.lastName??null,
      'phoneNumber': this.phoneNumber??null,
      'sex': this.sex??null,
      'address': this.address==null?null:this.address.toMap(),
      'email': this.email??null
    };
  }
}
