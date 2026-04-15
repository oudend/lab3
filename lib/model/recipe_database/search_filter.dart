import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:collection/collection.dart';

class SearchFilter {
  final String? difficulty;
  final double? minTime;
  final double? maxTime;
  final List<String>? cuisine;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? ingredients;
  final List<String>? mainIngredients;

  const SearchFilter({
    this.difficulty,
    this.minTime,
    this.maxTime,
    this.cuisine,
    this.minPrice = 0,
    this.maxPrice,
    this.ingredients,
    this.mainIngredients,
  });

  static const _listEq = ListEquality();

  bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null || a.isEmpty) a = null;
    if (b == null || b.isEmpty) b = null;
    return _listEq.equals(a, b);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchFilter) return false;

    return difficulty == other.difficulty &&
        minTime == other.minTime &&
        maxTime == other.maxTime &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        _listEquals(cuisine, other.cuisine) &&
        _listEquals(ingredients, other.ingredients) &&
        _listEquals(mainIngredients, other.mainIngredients);
  }

  @override
  int get hashCode {
    return Object.hash(
      difficulty,
      minTime,
      maxTime,
      minPrice,
      maxPrice,
      Object.hashAll(cuisine ?? []),
      Object.hashAll(ingredients ?? []),
      Object.hashAll(mainIngredients ?? []),
    );
  }

  bool matchAgainstRecipe(Recipe recipe) {
    if (difficulty != null && difficulty != recipe.difficulty) {
      return false;
    }

    if (cuisine != null &&
        !cuisine!.contains(recipe.cuisine) &&
        cuisine!.isNotEmpty) {
      return false;
    }

    if (minTime != null && recipe.time < minTime!) {
      return false;
    }

    if (maxTime != null && recipe.time > maxTime!) {
      return false;
    }

    if (minPrice != null && recipe.price < minPrice!) {
      return false;
    }

    if (maxPrice != null && recipe.price > maxPrice!) {
      return false;
    }

    if (ingredients != null && ingredients!.isNotEmpty) {
      final recipeIngredients = recipe.ingredients.map((e) => e.name).toSet();

      // ALL selected ingredients must exist in recipe
      for (final ingredient in ingredients!) {
        if (!recipeIngredients.contains(ingredient)) {
          return false;
        }
      }
    }

    if (mainIngredients != null && mainIngredients!.isNotEmpty) {
      if (!mainIngredients!.contains(recipe.mainIngredient)) {
        return false;
      }
    }

    return true;
  }
}
