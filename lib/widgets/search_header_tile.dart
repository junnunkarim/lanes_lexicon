import 'package:flutter/material.dart';

import '../classes/definition_provider.dart' show DefinitionProvider;

class SearchHeaderTile extends StatelessWidget {
  final DefinitionProvider definitionList;
  final VoidCallback onTap;

  const SearchHeaderTile({
    super.key,
    required this.definitionList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (definitionList.searchType == 'RootSearch') {
      return ListTile(
        title: Text(
          definitionList.searchWord!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: definitionList.definition.isEmpty
            ? const Text(
                'No results found.\nTap here for full text search.',
                textAlign: TextAlign.center,
              )
            : const Text(
                'Tap here for full text search.\nTo directly do a full text search press the Enter key instead of selecting from the dropdown.',
                textAlign: TextAlign.center,
              ),
        onTap: onTap,
      );
    } else if (definitionList.searchType == 'FullTextSearch') {
      if (definitionList.definition.length > 50 ||
          definitionList.definition.isEmpty) {
        return ListTile(
          title: Text(
            definitionList.searchWord!,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          subtitle: definitionList.definition.isEmpty
              ? const Text(
                  'No results found',
                  textAlign: TextAlign.center,
                )
              : const Text(
                  'Too many matches, results might be truncated.',
                  textAlign: TextAlign.center,
                ),
          onTap: () {},
        );
      }
      return ListTile(
        title: Text(
          definitionList.searchWord!,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container();
  }
}
