import 'package:beru/Schemas/BeruCategory.dart';
import 'package:flutter/material.dart';

class BloCForHome extends ChangeNotifier {
  BeruCategory category;
  setCategory(BeruCategory data) {
    this.category=data;
    notifyListeners();
  }
}
