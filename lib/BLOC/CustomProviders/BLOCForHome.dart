import 'package:beru/Schemas/BeruCategory.dart';
import 'package:flutter/material.dart';

enum BodyNav { first, second, middle, furth, fifth }

class BloCForHome extends ChangeNotifier {
  BodyNav select = BodyNav.first;
  BeruCategory category;

  setBodynav(BodyNav nav) {
    this.select = nav;
    notifyListeners();
  }

  setCategory(BeruCategory data) {
    this.category = data;
    notifyListeners();
  }
}
