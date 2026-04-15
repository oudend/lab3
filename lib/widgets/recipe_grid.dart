import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';
import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:lab2/model/recipe_database/search_filter.dart';
import 'package:lab2/widgets/recipe_card.dart';
import 'package:shimmer/shimmer.dart';

class RecipeGrid extends StatelessWidget {
  final Function(Recipe)? onTap;

  const RecipeGrid({super.key, this.onTap, required this.recipes});

  final List<Recipe>? recipes;

  Widget _buildGrid(bool isSkeleton) {
    return GridView.builder(
      controller: ScrollController(),
      padding: const EdgeInsets.all(AppTheme.paddingMediumSmall),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400, // target tile width
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.675, // 1 = square cells
      ),
      itemCount: isSkeleton ? 12 : recipes!.length,
      itemBuilder: (context, index) {
        Recipe? recipe = recipes?.elementAtOrNull(index);
        return RecipeCard(
          recipe: recipes?.elementAtOrNull(index),
          onTap: () {
            if (recipe != null) {
              onTap?.call(recipe);
            }
          },
          // layout: columns == 1 ? CardLayout.list : CardLayout.grid,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isSkeleton = recipes == null;

    final int columns = width < 600
        ? 1
        : width < 1000
        ? 2
        : 4;

    return isSkeleton
        ? Shimmer.fromColors(
            baseColor: AppTheme.shimmer.baseColor,
            highlightColor: AppTheme.shimmer.highlightColor,
            child: _buildGrid(isSkeleton),
          )
        : _buildGrid(isSkeleton);
  }
}
