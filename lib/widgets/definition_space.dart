import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/definition_provider.dart';
import '../screens/donate.dart';
import '../screens/favorites.dart';
import '../screens/quranic_words.dart';
import 'home_screen.dart';
import 'definition_list.dart';

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
