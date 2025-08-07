import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';

import '../classes/definition_provider.dart';
import '../classes/search_suggestions_provider.dart';
import '../constants/app_constants.dart';

class SearchSuggestionItem extends StatelessWidget {
  final String searchWord;
  final DefinitionProvider definitionListConsumer;
  final bool isLast;

  const SearchSuggestionItem({
    super.key,
    required this.searchWord,
    required this.definitionListConsumer,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SearchSuggestionsProvider>(context, listen: false);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _handleTap(context, model),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child: model.getHistory().contains(searchWord)
                        ? const Icon(
                            Icons.history,
                            key: Key('history'),
                          )
                        : const Icon(
                            Icons.label_important,
                            key: Key('word'),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        searchWord,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast && model.suggestions.isNotEmpty)
          const Divider(height: 0),
      ],
    );
  }

  void _handleTap(BuildContext context, SearchSuggestionsProvider model) async {
    if (searchWord.isEmpty) return;
    
    definitionListConsumer.searchType = allAlphabets.contains(searchWord.substring(0, 1))
        ? 'RootSearch'
        : 'FullTextSearch';
    definitionListConsumer.searchWord = searchWord;
    model.addHistory(searchWord);
    
    Future.delayed(
      const Duration(milliseconds: 50000),
      () => model.clear(),
    );
    
    FloatingSearchBar.of(context)?.close();
    
    try {
      DefinitionProvider value = await databaseObject.definition(
          searchWord, definitionListConsumer.searchType);
      definitionListConsumer.updateDefinition(
        value.id,
        value.word,
        value.definition,
        value.isRoot,
        value.highlight,
        searchWord,
        value.quranOccurrence,
        value.favoriteFlag,
      );
    } catch (e) {
      // Handle database error gracefully
      debugPrint('Error fetching definition: $e');
    }
  }
}
