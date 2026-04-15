import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';
import 'package:lab2/model/recipe_database/ingredient.dart';
import 'package:lab2/model/recipe_database/recipe_handler.dart';
import 'package:lab2/model/recipe_database/search_filter.dart';
import 'package:lab2/util/cuisine.dart';
import 'package:lab2/util/main_ingredient.dart';
import 'package:lab2/widgets/logo.dart';
import 'package:lab2/widgets/star_rating.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key, required this.onFilterChange});

  final Function(SearchFilter) onFilterChange;

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

// A helper widget to keep your build method clean
Widget _buildFilterColumn({required String label, required Widget child}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppTheme.paddingMediumSmall,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2.0,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        // const Spacer(), // Pushes the control to the right
        child,
      ],
    ),
  );
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  List<String>? _mainIngredients;
  List<String>? _ingredients;
  List<String>? _cuisine;
  int _difficultyIndex = 0;

  SfRangeValues _priceValues = SfRangeValues(0.0, 100.0);
  SfRangeValues _timeValues = SfRangeValues(0.0, 120.0);

  SearchFilter? _filter;

  Timer? _debounce;

  void _emitFilter() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      final filter = SearchFilter(
        difficulty: _difficultyIndex == 0
            ? null
            : ["easy", "medium", "hard"].elementAtOrNull(_difficultyIndex - 1),
        minTime: _timeValues.start,
        maxTime: _timeValues.end,
        minPrice: _priceValues.start,
        maxPrice: _priceValues.end,
        ingredients: _ingredients,
        cuisine: _cuisine,
        mainIngredients: _mainIngredients,
      );

      widget.onFilterChange.call(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    RecipeHandler recipeHandler = context.watch<RecipeHandler>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppTheme.paddingHuge),
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: const Logo(),
            ),
          ),
        ),

        const SizedBox(height: AppTheme.paddingHuge),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMediumSmall,
              vertical: AppTheme.paddingMediumSmall,
            ),
            child: Column(
              spacing: AppTheme.paddingMedium,
              children: [
                _buildFilterColumn(
                  child: MultiDropdown<String>(
                    key: ValueKey(
                      "main_ingredient_${recipeHandler.mainIngredients.length}",
                    ),
                    items: [
                      for (String ingredientName
                          in recipeHandler.mainIngredients)
                        DropdownItem(
                          label: ingredientName,
                          value: ingredientName,
                        ),
                    ],
                    itemBuilder: (item, index, onTap) {
                      return ListTile(
                        onTap: onTap,
                        leading: MainIngredient.icon(item.label, width: 24),
                        title: Text(item.label),
                        trailing: item.selected
                            ? const Icon(Icons.check)
                            : const SizedBox(width: 24),
                      );
                    },
                    onSelectionChange: (selectedItems) {
                      setState(() {
                        _mainIngredients = selectedItems;
                      });
                      _emitFilter();
                    },
                  ),
                  label: "Main Ingredient",
                ),
                _buildFilterColumn(
                  child: MultiDropdown<String>(
                    key: ValueKey("cuisines_${recipeHandler.cuisines.length}"),
                    itemBuilder: (item, index, onTap) {
                      return ListTile(
                        onTap: onTap,
                        leading: Cuisine.flag(item.label, width: 24),
                        title: Text(item.label),
                        trailing: item.selected
                            ? const Icon(Icons.check)
                            : const SizedBox(width: 24),
                      );
                    },
                    // singleSelect: true,
                    items: [
                      for (String cuisine in recipeHandler.cuisines)
                        DropdownItem(value: cuisine, label: cuisine),
                    ],
                    onSelectionChange: (selectedItems) {
                      setState(() {
                        _cuisine = selectedItems;
                      });
                      _emitFilter();
                    },
                  ),
                  label: "Cuisine",
                ),
                _buildFilterColumn(
                  child: MultiDropdown<String>(
                    key: ValueKey(
                      "ingredients_${recipeHandler.cuisines.length}",
                    ),
                    items: [
                      for (Ingredient ingredient in recipeHandler.ingredients)
                        DropdownItem(
                          label: ingredient.name,
                          value: ingredient.name,
                        ),
                    ],
                    onSelectionChange: (selectedItems) {
                      setState(() {
                        _ingredients = selectedItems;
                      });
                      _emitFilter();
                    },
                    searchEnabled: true,
                    searchDecoration: SearchFieldDecoration(
                      hintText: 'Type to search...',
                    ),
                  ),
                  label: "Ingredients",
                ),
                const Divider(thickness: 1),
                _buildFilterColumn(
                  child: Center(
                    child: DifficultyRating(
                      rating: _difficultyIndex,
                      switchDuration: 300,
                      maxRating: 3,
                      colors: [
                        Colors.orange.shade500,
                        Colors.orange.shade700,
                        Colors.orange.shade900,
                      ],
                      onRatingChanged: (newRating) {
                        setState(() {
                          _difficultyIndex = newRating;
                        });
                        _emitFilter();
                      },
                    ),
                  ),
                  label: "Difficulty",
                ),
                const Divider(thickness: 1),
                _buildFilterColumn(
                  child: SfRangeSlider(
                    min: 0.0,
                    max: 100.0,
                    values: _priceValues,
                    interval: 20,
                    stepSize: 5,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        _priceValues = values;
                      });
                      _emitFilter();
                    },
                  ),
                  label: "Price",
                ),
                _buildFilterColumn(
                  child: SfRangeSlider(
                    min: 0.0,
                    max: 120.0,
                    values: _timeValues,
                    interval: 20,
                    stepSize: 5,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        _timeValues = values;
                      });
                      _emitFilter();
                    },
                  ),
                  label: "Time",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
