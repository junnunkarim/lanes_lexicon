import 'package:flutter/material.dart';
import '../classes/definition_provider.dart';
import '../constants/app_constants.dart';

class FavoritesService {
  static void toggleFavorites(
      DefinitionProvider definitionList, int index, BuildContext context) {
    int toggleFavoriteFlag = definitionList.favoriteFlag[index - 1] == 1 ? 0 : 1;
    definitionList.favoriteFlag[index - 1] = toggleFavoriteFlag;
    databaseObject.toggleFavorites(
        definitionList.id[index - 1]!, toggleFavoriteFlag);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: definitionList.favoriteFlag[index - 1] == 1
            ? Text("Added ${definitionList.word[index - 1]} to favorites")
            : Text("Removed ${definitionList.word[index - 1]} from favorites"),
      ),
    );
  }
}
