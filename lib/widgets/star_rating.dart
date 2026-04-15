import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';

class DifficultyRating extends StatefulWidget {
  final int rating;
  final int maxRating;
  final Function(int) onRatingChanged;
  final List<Color> colors;
  final double size;
  final int switchDuration;

  final IconData filledIcon = Icons.local_fire_department;
  final IconData emptyIcon = Icons.local_fire_department_outlined;

  const DifficultyRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    required this.colors,
    this.switchDuration = 300,
    this.maxRating = 3,
    this.size = 40.0,
  });

  @override
  State<StatefulWidget> createState() => _DifficultyRatingState();
}

class _DifficultyRatingState extends State<DifficultyRating> {
  int _previousRating = 0;

  @override
  void initState() {
    super.initState();
    _previousRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    int ratingDifference = widget.rating - _previousRating;

    _previousRating = widget.rating;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        final bool isFilled = index < widget.rating;

        double start = ratingDifference == 0
            ? 0.0
            : (widget.rating - index - 1).abs() / ratingDifference.abs();

        start = ratingDifference > 0 ? 1 - start : start;

        start = start.isNaN ? 0 : start;

        return InkResponse(
          onTap: () => widget.onRatingChanged(
            index == widget.rating - 1 ? 0 : index + 1,
          ),
          radius: widget.size * 0.5,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingTiny,
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: widget.switchDuration),
              switchInCurve: Interval(
                start,
                1.0, // starts at 30% of controller time
                curve: Curves.bounceInOut,
              ),
              switchOutCurve: Interval(
                start,
                1.0, // starts at 30% of controller time
                curve: Curves.bounceInOut,
              ),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isFilled ? widget.filledIcon : widget.emptyIcon,
                key: ValueKey('widget.rating_${isFilled}_$index'),
                color: isFilled ? widget.colors[index] : Colors.grey.shade400,
                size: widget.size,
              ),
            ),
          ),
        );
      }),
    );
  }
}
