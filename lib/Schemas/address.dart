class Address {
  String houseName;
  String locality;
  String city;
  String district;
  String state;
  int pinCode;
  int alternateNumber;

  Address();

  Address.fromMap(Map<String, dynamic> data) {
    this.houseName = data['houseName'];
    this.locality = data['locality'];
    this.pinCode = data['pinCode'];
    this.city = data['city'];
    this.district = data['district'];
    this.state = data['state'];
    this.alternateNumber = data['alternateNumber'] ?? null;
  }
  Map<String, dynamic> toMap() {
    return {
      'houseName': this.houseName,
      'locality': this.locality,
      'pinCode': this.pinCode,
      'city': this.city,
      'district': this.district,
      'state': this.state,
      'alternateNumber': this.alternateNumber,
    };
  }
}
