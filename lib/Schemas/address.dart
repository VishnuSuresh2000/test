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
    this.houseName = data['houseName'] ?? null;
    this.locality = data['locality'] ?? null;
    this.pinCode = data['pinCode'] ?? null;
    this.city = data['city'] ?? null;
    this.district = data['district'] ?? null;
    this.state = data['state'] ?? null;
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
