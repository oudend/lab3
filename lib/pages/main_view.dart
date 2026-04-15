import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab2/model/recipe_database/recipe.dart';
import 'package:lab2/model/recipe_database/recipe_handler.dart';
import 'package:lab2/model/recipe_database/search_filter.dart';
import 'package:lab2/pages/recipe_view.dart';
import 'package:lab2/widgets/custom_search_bar.dart';
import 'package:lab2/widgets/recipe_grid.dart';
import 'package:lab2/widgets/search_filter_bar.dart';
import 'package:lab2/widgets/side_bar_view.dart';
import 'package:material_floating_search_bar_plus/material_floating_search_bar_plus.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _collapsed = false;
  bool _isWide = false;

  SearchFilter _filter = SearchFilter();
  String? _search;

  List<Recipe>? _cachedRecipes;

  String? _previousSearch;
  SearchFilter? _previousFilter;

  Widget _buildMainBodyHelper({
    required BuildContext context,
    required bool collapsed,
    required VoidCallback onToggleCollapsed,
    required List<Recipe>? recipes,
  }) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          RecipeGrid(
            recipes: recipes,
            onTap: (recipe) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RecipeView(recipe: recipe)),
              );
            },
          ),
          Center(
            child: CustomSearchBar(
              onSubmitted: (query) {
                setState(() => _search = query.isEmpty ? null : query);
              },
              leadingActions: [
                Tooltip(
                  message: "${collapsed ? "Open" : "Close"} filter menu",
                  child: FloatingSearchBarAction.icon(
                    showIfOpened: true,
                    icon: collapsed ? Icons.filter_alt : Icons.filter_alt_off,
                    onTap: onToggleCollapsed,
                  ),
                ),
              ],
              trailingActions: [
                FloatingSearchBarAction.icon(
                  icon: Icons.grid_view_rounded,
                  onTap: () {},
                ),
                FloatingSearchBarAction.icon(
                  icon: Icons.language,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBody({
    required BuildContext context,
    required bool collapsed,
    required VoidCallback onToggleCollapsed,
  }) {
    RecipeHandler recipeHandler = context.watch<RecipeHandler>();

    if (_previousSearch == _search && _previousFilter == _filter) {
      return _buildMainBodyHelper(
        collapsed: collapsed,
        context: context,
        onToggleCollapsed: onToggleCollapsed,
        recipes: _cachedRecipes,
      );
    }

    return FutureBuilder<List<Recipe>>(
      future: recipeHandler.matchRecipes(filter: _filter, text: _search),
      builder: (context, snapshot) {
        final recipes = snapshot.data;

        if (snapshot.hasData && recipeHandler.loaded) {
          _cachedRecipes = List.from(recipes!);
          _previousFilter = _filter;
          _previousSearch = _search;
        }

        return _buildMainBodyHelper(
          collapsed: collapsed,
          context: context,
          onToggleCollapsed: onToggleCollapsed,
          recipes: recipes,
        );
      },
    );
  }

  void openFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Filters"),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            body: SearchFilterBar(
              onFilterChange: (filter) {
                setState(() => _filter = filter);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = MediaQuery.of(context).size.width;

        final isWide = pageWidth >= 700;

        if (_isWide != isWide) {
          _collapsed = true;
          _isWide = isWide;
        }

        if (isWide) {
          return Material(
            child: AnimatedSideBarView(
              minBarWidth: 300, // 10% of width
              maxBarWidth: max(300, pageWidth * 0.40), // 40% of width
              collapsed: _collapsed,
              handleWidth: 6,
              duration: Duration(milliseconds: 250),
              curve: Curves.ease,
              onCollapse: (collapsed) => setState(() => _collapsed = collapsed),
              sideBar: SearchFilterBar(
                onFilterChange: (filter) {
                  setState(() => _filter = filter);
                },
              ),
              child: _buildMainBody(
                context: context,
                collapsed: _collapsed,
                onToggleCollapsed: () =>
                    setState(() => _collapsed = !_collapsed),
              ),
            ),
          );
        }

        return Material(
          child: _buildMainBody(
            context: context,
            collapsed: _collapsed,
            onToggleCollapsed: () => openFilters(context),
          ),
        );
      },
    );
  }
}
