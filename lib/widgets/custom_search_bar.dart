import 'package:flutter/material.dart';
import 'package:lab2/app_theme.dart';
import 'package:material_floating_search_bar_plus/material_floating_search_bar_plus.dart';

class CustomSearchBar extends StatelessWidget {
  final List<Widget>? leadingActions;
  final List<Widget>? trailingActions;
  final OnQueryChangedCallback? onSubmitted;

  const CustomSearchBar({
    super.key,
    this.leadingActions,
    this.trailingActions,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    // final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      automaticallyImplyBackButton: false,
      scrollPadding: const EdgeInsets.only(
        top: AppTheme.paddingMedium,
        bottom: AppTheme.paddingMedium,
      ),
      onSubmitted: onSubmitted,
      // transitionDuration: const Duration(milliseconds: 800),
      // transitionCurve: Curves.easeInOut,
      backdropColor: Colors.transparent,
      physics: const BouncingScrollPhysics(),
      // axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      // width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: onSubmitted,
      leadingActions: leadingActions,
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        ...?trailingActions,
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            // child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [Text("hello")],
            // ),
          ),
        );
      },
    );
  }
}
