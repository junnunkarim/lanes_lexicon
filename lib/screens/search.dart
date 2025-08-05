import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:provider/provider.dart';

import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import '../classes/definition_provider.dart';
import '../classes/search_suggestions_provider.dart';
import '../widgets/definition_space.dart';
import '../widgets/drawer.dart';
import '../constants/app_constants.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DefinitionProvider>(
      builder: (_, definitionProvider, __) {
        return PopScope(
          canPop: definitionProvider.searchType == null,
          onPopInvoked: (didPop) {
            if (!didPop && definitionProvider.searchType != null) {
              definitionProvider.searchType = null;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: const CommonDrawer(currentScreen: 'Search'),
            body: buildSearchBar(definitionProvider),
          ),
        );
      },
    );
  }

  Widget buildSearchBar(DefinitionProvider definitionProvider) {
    final actions = [
      FloatingSearchBarAction.searchToClear(showIfClosed: true),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.sizeOf(context).width;

    return Consumer<SearchSuggestionsProvider>(
      builder: (context, suggestionProvider, _) => FloatingSearchBar(
        controller: controller,
        clearQueryOnClose: false,
        hint: 'Arabic/English العربية/الإنكليزية',
        transitionDuration: const Duration(milliseconds: 300),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        debounceDelay: const Duration(milliseconds: 500),
        axisAlignment: 0.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? width : 800,
        borderRadius: BorderRadius.circular(30),
        actions: actions,
        progress: suggestionProvider.isLoading,
        onSubmitted: (query) =>
            _handleSearch(query, definitionProvider, suggestionProvider),
        onFocusChanged: (isFocused) {},
        onQueryChanged: suggestionProvider.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, _) => Padding(
          padding: const EdgeInsets.only(top: 15),
          child: buildExpandableBody(suggestionProvider, definitionProvider),
        ),
        body: const DefinitionSpace(),
      ),
    );
  }

  void _handleSearch(String query, DefinitionProvider definitionProvider,
      SearchSuggestionsProvider suggestionProvider) {
    controller.close();
    suggestionProvider.addHistory(query);

    // Clear suggestions after closing
    Future.delayed(
        const Duration(milliseconds: 500), () => suggestionProvider.clear());

    _performSearch(query, definitionProvider);
  }

  String _getSearchType(String searchWord) {
    return _isArabic(searchWord) ? 'RootSearch' : 'FullTextSearch';
  }

  Future<void> _performSearch(
      String searchWord, DefinitionProvider definitionProvider) async {
    try {
      definitionProvider.searchWord = searchWord;
      final searchType = _getSearchType(searchWord);
      definitionProvider.searchType = searchType;

      final result = await databaseObject.definition(searchWord, searchType);

      definitionProvider.updateDefinition(
        result.id,
        result.word,
        result.definition,
        result.isRoot,
        result.highlight,
        searchWord,
        result.quranOccurrence,
        result.favoriteFlag,
      );
    } catch (e) {
      // handle error
      debugPrint('Search error: $e');
    }
  }

  Widget buildExpandableBody(
    SearchSuggestionsProvider suggestionProvider,
    DefinitionProvider definitionProvider,
  ) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(30),
      child: ImplicitlyAnimatedList<String>(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        items: suggestionProvider.suggestions.take(6).toList(),
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, searchWord, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(
                context, searchWord, suggestionProvider, definitionProvider),
          );
        },
        updateItemBuilder: (context, animation, searchWord) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(
                context, searchWord, suggestionProvider, definitionProvider),
          );
        },
      ),
    );
  }

  Widget buildItem(
      BuildContext context,
      String searchWord,
      SearchSuggestionsProvider suggestionProvider,
      DefinitionProvider definitionProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () =>
              _handleSearch(searchWord, definitionProvider, suggestionProvider),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child: suggestionProvider.getHistory().contains(searchWord)
                        ? const Icon(Icons.history, key: Key('history'))
                        : const Icon(Icons.label_important, key: Key('word')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    searchWord,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (suggestionProvider.suggestions.isNotEmpty &&
            searchWord != suggestionProvider.suggestions.last)
          const Divider(height: 0),
      ],
    );
  }

  bool _isArabic(String text) {
    if (text.isEmpty) return false;
    final firstChar = text.substring(0, 1);
    // Check if first character is Arabic (Unicode range)
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(firstChar);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
