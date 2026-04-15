import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_bolt/fuzzy_bolt.dart';
import 'package:lab2/model/recipe_database/ingredient.dart';
import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:lab2/model/recipe_database/search_filter.dart';

class RecipeHandler extends ChangeNotifier {
  final List<Recipe> _recipes = [];
  final Set<Ingredient> _ingredients = {};
  final Set<String> _mainIngredients = {};
  final Set<String> _cuisines = {};
  List<Recipe> _matchedRecipes = [];

  RecipeHandler() {
    _loadRecipes();
  }

  bool loaded = false;

  List<Recipe> get recipes => _recipes;

  List<Recipe> get bestMatches => _matchedRecipes;

  Set<Ingredient> get ingredients => _ingredients;

  Set<String> get mainIngredients => _mainIngredients;

  Set<String> get cuisines => _cuisines;

  void clearFilter() {
    _matchedRecipes = List.from(recipes);
  }

  Future<List<Recipe>> matchRecipes({
    required SearchFilter? filter,
    FuzzySearchConfig strictConfig = const FuzzySearchConfig(
      strictThreshold: 0.5,
      typeThreshold: 0.5,
      maxResults: 25,
    ),
    String? text,
  }) async {
    List<Recipe> candidates = List.from(recipes);

    if (filter != null) {
      candidates.removeWhere((a) => !filter.matchAgainstRecipe(a));
    }

    if (text != null && text.trim().isNotEmpty) {
      final fuzzyResults =
          await FuzzyBolt.searchWithConfig<Recipe>(candidates, text.trim(), [
            (r) => r.name,
            (r) => r.description,
            (r) => r.instruction,
            (r) => r.cuisine,
            (r) => r.mainIngredient,
          ], strictConfig);

      candidates = fuzzyResults.map((e) => e.item).toList();
    }

    return candidates;
  }

  void _loadRecipes() async {
    final String jsonString = await rootBundle.loadString(
      'assets/recipes/recipes.json',
    );

    List data = jsonDecode(jsonString);

    for (int i = 0; i < data.length; i++) {
      var recipe = Recipe.fromJson(data[i]);
      _recipes.add(recipe);
      _ingredients.addAll(recipe.ingredients);
      _cuisines.add(recipe.cuisine);
      _mainIngredients.add(recipe.mainIngredient);
    }

    _matchedRecipes.addAll(_recipes);

    notifyListeners();
    loaded = true;
  }
}
