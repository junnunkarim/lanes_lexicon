import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/definition_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/definition_space.dart';
import '../widgets/drawer.dart';
import '../widgets/search_bar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = min(value, 2);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DefinitionProvider>(
      builder: (_, definitionListConsumer, __) {
        return WillPopScope(
          onWillPop: () {
            if (definitionListConsumer.searchType == null) {
              return Future.value(true);
            }
            definitionListConsumer.searchType = null;
            return Future.value(false);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            drawer: const CommonDrawer(currentScreen: searchScreenTitle),
            body: FloatingSearchBarWidget(
              onIndexChanged: (newIndex) => index = newIndex,
              definitionSpace: _buildDefinitionSpace(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefinitionSpace() {
    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: min(index, 2),
            children: const [
              DefinitionSpace(),
            ],
          ),
        ),
      ],
    );
  }
}
