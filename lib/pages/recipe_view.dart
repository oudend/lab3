import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';
import 'package:lab2/model/recipe_database/ingredient.dart';
import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:lab2/util/cuisine.dart';
import 'package:lab2/util/main_ingredient.dart';
import 'package:lab2/widgets/recipe_info_row.dart';
import 'package:lab2/widgets/side_bar_view.dart';
import 'package:lab2/widgets/star_rating.dart';

Widget _image(Recipe recipe) {
  var square = ClipRect(
    child: SizedBox(
      width: double.infinity, // Square width
      height: double.infinity, // Square height
      child: FittedBox(fit: BoxFit.cover, child: recipe.image),
    ),
  );
  var flagImage = Cuisine.flag(recipe.cuisine, width: 24.0);

  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: square,
      ),
      Positioned(
        bottom: 8,
        right: 8,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(2), // optional
          ),
          child: flagImage!,
        ),
      ),
    ],
  );
}

Widget _infoColumn(Recipe recipe) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    spacing: AppTheme.paddingMedium * 2,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
            child: AspectRatio(
              aspectRatio: 1, // square
              child: _image(recipe),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                double size = 32;

                if (width < 500) size = 16;
                if (width < 200) size = 8;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // off-color background
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(AppTheme.paddingMedium),
                    child: RecipeInfoRow(
                      recipe: recipe,
                      size: size,
                      scaleToFit: false,
                      compactText: false,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      Text(recipe.description),
      Column(
        spacing: AppTheme.paddingMediumSmall * 2,
        children: [
          for (Ingredient ingredient in recipe.ingredients)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(value: true, onChanged: (value) {}),
                Text(
                  "${ingredient.amount} ${ingredient.unit} ${ingredient.name}",
                ),
              ],
            ),
        ],
      ),
    ],
  );
}

Widget _instructionColumn(Recipe recipe) {
  final steps = recipe.instruction
      .split('.')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppTheme.paddingMedium,
    children: [
      for (String text in steps)
        Text(
          style: AppTheme.textTheme.bodyLarge?.copyWith(fontSize: 32),
          "${text.trimLeft()}.",
        ),
    ],
  );
}

class RecipeView extends StatelessWidget {
  final Recipe recipe;

  const RecipeView({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;

    final isCompact = pageWidth < 700;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: isCompact
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(AppTheme.paddingMedium),
                child: Column(
                  spacing: AppTheme.paddingHuge,
                  children: [_infoColumn(recipe), _instructionColumn(recipe)],
                ),
              ),
            )
          : AnimatedSideBarView(
              minBarWidth: 300, // 10% of width
              maxBarWidth: max(300, pageWidth * 0.40), // 40% of width
              onCollapse: (collapsed) {},
              collapsed: false,
              sideBar: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(AppTheme.paddingMedium),
                  child: _infoColumn(recipe),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(AppTheme.paddingMedium),
                  child: _instructionColumn(recipe),
                ),
              ),
            ),
    );
  }
}
