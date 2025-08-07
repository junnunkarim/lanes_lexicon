import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../classes/app_theme.dart';
import '../../classes/definition_provider.dart';
import '../../service_locator.dart';
import '../../services/local_storage_service.dart';
import '../services/context_menu_service.dart';
import 'fav_icon_widget.dart' show FavIconWidget;
import 'quran_occurrence_alert.dart' show quranOccurrenceDialog;

class DefinitionTile extends StatelessWidget {
  final DefinitionProvider? definitionList;
  final int? index;
  
  const DefinitionTile({
    super.key,
    this.definitionList,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    Offset tapPosition = const Offset(10.0, 10.0);
    
    return GestureDetector(
      child: ListTile(
        isThreeLine: true,
        selected: definitionList!.highlight[index! - 1] == 1,
        selectedTileColor:
           hexToColor(locator<LocalStorageService>().highlightTileColor),
        contentPadding: EdgeInsets.fromLTRB(
            definitionList!.isRoot[index! - 1] == 1 ? 16.0 : 50, 0, 16, 0),
        title: HtmlWidget(
          definitionList!.definition[index! - 1]!,
          textStyle: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            definitionList!.isRoot[index! - 1] == 1
                ? FavIconWidget(definitionList: definitionList, index: index)
                : Container(),
            definitionList!.quranOccurrence![index! - 1] != null
                ? ElevatedButton(
                    onPressed: () {
                      if (definitionList!.quranOccurrence![index! - 1] !=
                          null) {
                        quranOccurrenceDialog(
                            context,
                            definitionList!.quranOccurrence![index! - 1]!,
                            definitionList!.word[index! - 1]!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "Q - ${definitionList!.quranOccurrence![index! - 1]}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  )
                : Container(),
          ],
        ),
        onTap: () {},
        onLongPress: () {
          ContextMenuService.showContextMenu(
            context,
            tapPosition,
            definitionList!,
            index!,
          );
        },
      ),
      onTapDown: (details) => tapPosition = details.globalPosition,
    );
  }
}
