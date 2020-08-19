class BeruCategory {
  String _id;
  String name;
  bool hasImg;

  String get id {
    return _id;
  }

  set id(String id) {
    this._id = id;
  }

  BeruCategory();
  BeruCategory.fromMap(Map<String, dynamic> data) {
    this._id = data['_id'] ?? null;
    this.name = data['name'] ?? null;
    this.hasImg = data['hasImg'] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {'_id': this._id, 'name': this.name};
  }
}
