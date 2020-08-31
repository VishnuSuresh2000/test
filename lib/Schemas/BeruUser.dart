import 'package:beru/CustomFunctions/BeruString.dart';
import 'package:beru/Schemas/address.dart';

class BeruUser {
  String firstName;
  String lastName;
  int phoneNumber;
  String email;
  Address address;
  String _id;
  bool sex;
  String get fullName {
    return "${firstToUpperCaseString(firstName)} ${firstToUpperCaseString(lastName ?? "")}";
  }

  String get id {
    return _id;
  }

  set id(String id) {
    this._id = id;
  }

  BeruUser();
  BeruUser.fromMap(Map<String, dynamic> data) {
    this._id = data['_id'] ?? null;
    this.firstName = data['firstName'] ?? null;
    this.lastName = data['lastName'] ?? null;
    this.phoneNumber = data['phoneNumber'] ?? null;
    this.sex = data['sex'] ?? null;
    this.address =
        data['address'] == null ? null : Address.fromMap(data['address']);
    this.email = data['email'] ?? null;
  }
  BeruUser.fromMapTest(Map<String, dynamic> data) {
    this.firstName = data['firstName'] ?? null;
    this.lastName = data['lastName'] ?? null;
    this.phoneNumber = data['phoneNumber'] ?? null;
    this.sex = data['sex'] ?? null;
    this.address =
        data['address'] == null ? null : Address.fromMap(data['address']);
    this.email = data['email'] ?? null;
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': this.firstName ?? null,
      'lastName': this.lastName ?? null,
      'phoneNumber': this.phoneNumber ?? null,
      'sex': this.sex ?? null,
      'address': this.address == null ? null : this.address.toMap(),
      'email': this.email ?? null
    };
  }

  Map<String, dynamic> toMapForBUserRegister() {
    return {
      'firstName': this.firstName ?? null,
      'lastName': this.lastName ?? null,
      'phoneNumber': this.phoneNumber ?? null,
      'sex': this.sex ?? null,
      'email': this.email ?? null
    };
  }
}
