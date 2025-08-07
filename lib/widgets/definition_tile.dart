// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../classes/app_theme.dart';
import '../../classes/definition_provider.dart';
import '../../service_locator.dart';
import '../../services/local_storage_service.dart';
import '../services/context_menu_service.dart';
import 'fav_icon_widget.dart' show FavIconWidget;
import 'quran_occurrence_alert.dart' show quranOccurrenceDialog;

// String extractWord(String html) {
//   final regex = RegExp(r'<h3[^>]*>(.*?)</h3>', dotAll: true);
//   final match = regex.firstMatch(html);
//
//   return match?.group(1)?.trim() ?? '';
// }

// void toPythonUnicodeBytes(String input) {
//   StringBuffer buffer = StringBuffer("b'");
//   for (int rune in input.runes) {
//     if (rune <= 0x7F) {
//       // ASCII characters
//       if (rune == 0x5C) {
//         buffer.write(r'\\'); // Escape backslash
//       } else if (rune == 0x27) {
//         buffer.write(r"\'"); // Escape single quote
//       } else {
//         buffer.write(String.fromCharCode(rune));
//       }
//     } else {
//       // Non-ASCII → convert to \uXXXX format
//       buffer
//           .write('\\u${rune.toRadixString(16).padLeft(4, '0').toUpperCase()}');
//     }
//   }
//   buffer.write("'");
//   print(buffer.toString());
// }

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

    Widget rootBlock = HtmlWidget(
      definitionList!.definition[index! - 1]!,
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
        fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! * 2,
      ),
    );

    // String wordTitle = extractWord(definitionList!.definition[index! - 1]!);
    // Widget definitionBlock = Theme(
    //   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    //   child: ExpansionTile(
    //     title: Text(
    //       wordTitle,
    //       style: TextStyle(
    //         fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
    //         fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
    //       ),
    //     ),
    //     initiallyExpanded: definitionList!.highlight[index! - 1] == 1,
    //     tilePadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    //     collapsedShape: null,
    //     expandedCrossAxisAlignment: CrossAxisAlignment.start,
    //     expandedAlignment: Alignment.topLeft,
    //     children: [
    //       HtmlWidget(
    //         definitionList!.definition[index! - 1]!,
    //         textStyle: TextStyle(
    //           fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
    //           fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    Widget definitionBlock = Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: HtmlWidget(
        definitionList!.definition[index! - 1]!,
        textStyle: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
        ),
      ),
    );

    // for debugging and testing
    // const String testBidi =
    //     "<h2>أَبَّ\u200E (1: فَعَل/فَعُل/فَعِل)</h2><br /><b>SIGNIFICATION (___)</b><br /> This is something to view right now in the lower level. <br /><b>DISSOCIATION (===)</b><br />This is something to view right now in the lower level.";
    // toPythonUnicodeBytes("<h3>أَبَّ | 1: فَعَل/فَعُل/فَعِل</h3>");
    // toPythonUnicodeBytes(definitionList!.definition[index! - 1]!);

    return GestureDetector(
      child: ListTile(
        isThreeLine: true,
        selected: definitionList!.highlight[index! - 1] == 1,
        selectedTileColor:
            hexToColor(locator<LocalStorageService>().highlightTileColor),
        contentPadding: EdgeInsets.fromLTRB(
            definitionList!.isRoot[index! - 1] == 1 ? 16.0 : 30, 0, 10, 0),
        title: definitionList!.isRoot[index! - 1] == 1
            ? rootBlock
            : definitionBlock,
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
