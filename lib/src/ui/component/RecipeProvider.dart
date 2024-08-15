import 'package:flutter/material.dart';

class RecipeProvider extends ChangeNotifier {
  List<Map<String,dynamic>> _recipes = [];

  List<Map<String,dynamic>> get recipes => _recipes;

  void updateRecipes(List<Map<String,dynamic>> newRecipes) {
    _recipes = newRecipes;
    notifyListeners();  // 상태 변경 알림
  }

  void addRecipe(Map<String,dynamic> recipe) {
    _recipes.add(recipe);
    notifyListeners();  // 상태 변경 알림
  }


}