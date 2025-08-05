import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/definition_provider.dart' show DefinitionProvider;
import '../screens/donate.dart' show Donate;
import '../screens/favorites.dart' show Favorites;
import '../screens/quranic_words.dart' show QuranicWords;
import 'definition_list.dart' show DefinitionList;
import 'home_screen.dart' show HomeScreen;

class DefinitionSpace extends StatefulWidget {
  const DefinitionSpace({
    super.key,
  });
  
  @override
  State<DefinitionSpace> createState() => _DefinitionSpaceState();
}

class _DefinitionSpaceState extends State<DefinitionSpace> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DefinitionProvider>(
      builder: (_, definitionList, __) {
        Widget bodyContent;

        if (definitionList.searchType == null) {
          bodyContent = const HomeScreen();
        } else if (definitionList.searchType == '/favorites') {
          bodyContent = const Favorites();
        } else if (definitionList.searchType == '/donate') {
          bodyContent = const Donate();
        } else if (definitionList.searchType == '/quranicWords') {
          bodyContent = const QuranicWords();
        } else {
          bodyContent = DefinitionList(definitionList: definitionList);
        }

        return bodyContent;
      },
    );
  }
}
