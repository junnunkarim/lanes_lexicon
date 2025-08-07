import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';

import '../classes/definition_provider.dart';
import '../classes/search_suggestions_provider.dart';
import 'search_suggestion_item.dart';

class SearchSuggestionsList extends StatelessWidget {
  final FloatingSearchBarController controller;
  final DefinitionProvider definitionListConsumer;

  const SearchSuggestionsList({
    super.key,
    required this.controller,
    required this.definitionListConsumer,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchSuggestionsProvider>(
      builder: (context, model, _) => Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(25),
        child: ImplicitlyAnimatedList<String>(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          items: model.suggestions.take(6).toList(),
          areItemsTheSame: (a, b) => a == b,
          itemBuilder: (context, animation, searchWord, i) {
            final suggestions = model.suggestions.take(6).toList();
            return SizeFadeTransition(
              animation: animation,
              child: SearchSuggestionItem(
                searchWord: searchWord,
                definitionListConsumer: definitionListConsumer,
                isLast: suggestions.isNotEmpty && searchWord == suggestions.last,
              ),
            );
          },
          updateItemBuilder: (context, animation, searchWord) {
            final suggestions = model.suggestions.take(6).toList();
            return FadeTransition(
              opacity: animation,
              child: SearchSuggestionItem(
                searchWord: searchWord,
                definitionListConsumer: definitionListConsumer,
                isLast: suggestions.isNotEmpty && searchWord == suggestions.last,
              ),
            );
          },
        ),
      ),
    );
  }
}
