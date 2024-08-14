import 'package:flutter/material.dart';

class RecipeProvider extends ChangeNotifier {
  List<String> _recipes = [];

  List<String> get recipes => _recipes;

  void updateRecipes(List<String> newRecipes) {
    _recipes = newRecipes;
    notifyListeners();  // 상태 변경 알림
  }

  void addRecipe(String recipe) {
    _recipes.add(recipe);
    notifyListeners();  // 상태 변경 알림
  }


}