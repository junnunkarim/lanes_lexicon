import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:provider/provider.dart';

import '../classes/definition_provider.dart';
import '../classes/search_suggestions_provider.dart';
import '../services/search_handler.dart';
import 'search_suggestions_list.dart';

class FloatingSearchBarWidget extends StatefulWidget {
  final Function(int) onIndexChanged;
  final Widget definitionSpace;

  const FloatingSearchBarWidget({
    super.key,
    required this.onIndexChanged,
    required this.definitionSpace,
  });

  @override
  State<FloatingSearchBarWidget> createState() =>
      _FloatingSearchBarWidgetState();
}

class _FloatingSearchBarWidgetState extends State<FloatingSearchBarWidget> {
  final controller = FloatingSearchBarController();

  int _index = 0;
  int get index => _index;
  set index(int value) {
    _index = value;
    _index == 2 ? controller.hide() : controller.show();
    widget.onIndexChanged(_index);
  }

  @override
  Widget build(BuildContext context) {
    final definitionListConsumer = Provider.of<DefinitionProvider>(context);
    final actions = [
      FloatingSearchBarAction.searchToClear(
        showIfClosed: true,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double width = MediaQuery.sizeOf(context).width;

    return Consumer<SearchSuggestionsProvider>(
      builder: (context, model, _) => FloatingSearchBar(
        controller: controller,
        clearQueryOnClose: false,
        hint: 'Arabic/English العربية/الإنكليزية',
        transitionDuration: const Duration(milliseconds: 300),
        transitionCurve: Curves.easeInOutCubic,
        physics: const BouncingScrollPhysics(),
        debounceDelay: const Duration(milliseconds: 400),
        axisAlignment: isPortrait ? 0.0 : 0.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? width : 800,
        borderRadius: BorderRadius.circular(30),
        actions: actions,
        progress: model.isLoading,
        onSubmitted: (query) =>
            _handleSubmission(query, model, definitionListConsumer),
        onFocusChanged: (isFocused) {},
        onQueryChanged: model.onQueryChanged,
        scrollPadding: EdgeInsets.zero,
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, _) => Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SearchSuggestionsList(
            controller: controller,
            definitionListConsumer: definitionListConsumer,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
          ),
          child: widget.definitionSpace,
        ),
      ),
    );
  }

  void _handleSubmission(String query, SearchSuggestionsProvider model,
      DefinitionProvider definitionListConsumer) {
    controller.close();
    model.addHistory(query);
    SearchHandler.handleDefinitionSearch(
      context,
      query,
      definitionListConsumer,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
