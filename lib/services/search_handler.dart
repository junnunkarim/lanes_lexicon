import 'package:flutter/material.dart';

import '../classes/definition_provider.dart';
import '../constants/app_constants.dart';

class SearchHandler {
  static Future<void> handleDefinitionSearch(
    BuildContext context,
    String searchWord,
    DefinitionProvider definitionListConsumer,
  ) async {
    if (searchWord.isEmpty) return;
    
    definitionListConsumer.searchWord = searchWord;
    definitionListConsumer.searchType = 'FullTextSearch';
    
    try {
      DefinitionProvider value = await databaseObject.definition(
        searchWord, 
        'FullTextSearch',
      );
      
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
