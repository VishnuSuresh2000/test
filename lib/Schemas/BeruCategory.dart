class BeruCategory {
  String _id;
  String name;
  
  String get id {
    return _id;
  }

  set id(String id) {
    this._id = id;
  }

  BeruCategory();
  BeruCategory.fromMap(Map<String, dynamic> data) {
    this._id = data['_id'];
    this.name = data['name'];
  }

  Map<String, dynamic> toMap() {
    return {'_id': this._id, 'name': this.name};
  }
}
