import 'package:beru/Schemas/address.dart';

class User {
  String firstName;
  String lastName;
  int phoneNumber;
  String email;
  Address address;
  String _id;
  bool sex;
  bool userFirbase;
  bool userSignUp;
  bool userStatus; //true siginin, false sigin out
  bool serverError=false;
  Exception error;
  String get fullName {
    return "$firstName $lastName";
  }

  String get id {
    return _id;
  }

  set id(String id) {
    this._id = id;
  }

  User();
  User.fromMap(Map<String, dynamic> data) {
    this.firstName = data['firstName'];
    this.lastName = data['lastName'];
    this.phoneNumber = data['phoneNumber'];
    this.sex = data['sex'];
    this.address = Address.fromMap(data['address']);
    this.email = data['email'];
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phoneNumber': this.phoneNumber,
      'sex': this.sex,
      'address': this.address.toMap(),
      'email': this.email
    };
  }
}
