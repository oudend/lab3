import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';
import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:lab2/util/cuisine.dart';
import 'package:lab2/util/main_ingredient.dart';
import 'package:lab2/widgets/recipe_info_row.dart';
import 'package:lab2/widgets/star_rating.dart';

import 'package:shimmer/shimmer.dart';

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
      ClipRRect(borderRadius: BorderRadius.circular(16), child: square),
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

class RecipeCard extends StatefulWidget {
  final Recipe? recipe;

  final GestureTapCallback? onTap;

  const RecipeCard({required this.recipe, this.onTap, super.key});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;

    final bool isSkeleton = widget.recipe == null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        bool isCompact = cardWidth < 300;

        return Card(
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            onTap: widget.onTap,
            onHover: (hovering) {
              setState(() {
                _hovering = hovering;
              });
            },
            child: SizedBox(
              height: 128,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(AppTheme.paddingMedium),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: ClipRect(
                          child: AnimatedScale(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            scale: _hovering ? 1.05 : 1,
                            child: isSkeleton
                                ? _emptyContainer()
                                : _image(widget.recipe!),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(AppTheme.paddingMedium),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              bottom: AppTheme.paddingMedium,
                            ),
                            child: isSkeleton
                                ? _emptyContainer(height: 20, width: 64)
                                : Text(
                                    widget.recipe!.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: style?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),

                          // const Divider(thickness: 1),
                          Expanded(
                            child: isSkeleton
                                ? _emptyContainer(height: 32)
                                : Text(
                                    widget.recipe!.description,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: style!.color?.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                    maxLines: 3,
                                  ),
                          ),

                          // const Spacer(),

                          // const Divider(thickness: 1),
                          RecipeInfoRow(
                            recipe: widget.recipe,
                            size: 16,
                            scaleToFit: false,
                            compactText: isCompact,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
