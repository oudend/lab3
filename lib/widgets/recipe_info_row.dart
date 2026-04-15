import 'package:flutter/material.dart';
import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:lab2/util/main_ingredient.dart';
import 'package:lab2/widgets/star_rating.dart';

Widget _emptyContainer({
  double width = double.infinity,
  double height = double.infinity,
  BorderRadius? radius,
}) {
  return Container(
    width: width,
    height: height,
    color: Colors.white,
    // decoration: BoxDecoration(
    //   color: Colors.white,
    //   borderRadius: radius ?? BorderRadius.circular(16),
    // ),
  );
}

class RecipeInfoRow extends StatelessWidget {
  final Recipe? recipe;

  final double size; // controls icons/text/divider height
  final bool scaleToFit; // if true, scales down to fit parent width
  final bool compactText;

  const RecipeInfoRow({
    super.key,
    this.recipe,
    this.size = 16,
    this.scaleToFit = false,
    this.compactText = false,
  });

  Widget _divider(double size) {
    return Container(width: 1, height: size, color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    bool isSkeleton = recipe == null;

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        isSkeleton
            ? _emptyContainer(width: size, height: size)
            : (MainIngredient.icon(recipe!.mainIngredient, width: size) ??
                  Text(
                    recipe!.mainIngredient,
                    style: TextStyle(fontSize: size),
                  )),

        _divider(size),

        isSkeleton
            ? _emptyContainer(width: size * 3, height: size)
            : DifficultyRating(
                rating: recipe!.difficultyIndex + 1,
                maxRating: 3,
                colors: [
                  Colors.orange.shade500,
                  Colors.orange.shade700,
                  Colors.orange.shade900,
                ],
                size: size,
                onRatingChanged: (_) {},
              ),

        _divider(size),

        isSkeleton
            ? _emptyContainer(width: size * 2, height: size)
            : Text(
                "${recipe!.time} ${compactText ? "" : "minuter"}",
                style: TextStyle(fontSize: size),
              ),

        _divider(size),

        isSkeleton
            ? _emptyContainer(width: size * 2, height: size)
            : Text(
                "${recipe!.price} ${compactText ? "" : "kr"}",
                style: TextStyle(fontSize: size),
              ),
      ],
    );

    if (!scaleToFit) return row;

    // scales down if needed to fit the parent width
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: row,
    );
  }
}
