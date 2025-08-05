import 'package:flutter/material.dart';

import '../../classes/app_theme.dart';
import '../../classes/definition_provider.dart';
import '../../service_locator.dart';
import '../../services/local_storage_service.dart';
import '../constants/app_constants.dart';
import 'definition_tile.dart' show DefinitionTile;
import 'search_header_tile.dart' show SearchHeaderTile;

class DefinitionList extends StatefulWidget {
  final DefinitionProvider definitionList;
  
  const DefinitionList({
    super.key,
    required this.definitionList,
  });

  @override
  State<DefinitionList> createState() => _DefinitionListState();
}

class _DefinitionListState extends State<DefinitionList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 100),
      itemCount: widget.definitionList.definition.length + 1,
      separatorBuilder: (context, index) {
        return widget.definitionList.isRoot[index] == 1
            ? const Divider()
            : Container();
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return SearchHeaderTile(
            definitionList: widget.definitionList,
            onTap: () async {
              widget.definitionList.searchType = 'FullTextSearch';
              DefinitionProvider value = await databaseObject.definition(
                  widget.definitionList.searchWord,
                  widget.definitionList.searchType);
              setState(() {
                widget.definitionList.id = value.id;
                widget.definitionList.word = value.word;
                widget.definitionList.definition = value.definition;
                widget.definitionList.isRoot = value.isRoot;
                widget.definitionList.highlight = value.highlight;
                widget.definitionList.quranOccurrence = value.quranOccurrence;
                widget.definitionList.favoriteFlag = value.favoriteFlag;
              });
            },
          );
        }
        
        return ListTileTheme(
          selectedColor: hexToColor(
              locator<LocalStorageService>().highlightTextColor),
          child: DefinitionTile(
              definitionList: widget.definitionList, index: index),
        );
      },
    );
  }
}
