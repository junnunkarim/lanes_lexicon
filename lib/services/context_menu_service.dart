import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';

import '../classes/definition_provider.dart' show DefinitionProvider;

class ContextMenuService {
  static Future<void> showContextMenu(
    BuildContext context,
    Offset tapPosition,
    DefinitionProvider definitionList,
    int index,
  ) async {
    int? choice = await showMenu(
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              Overlay.of(context)
                  .context
                  .findRenderObject()!
                  .semanticBounds
                  .size),
      items: [
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.copy),
              SizedBox(
                width: 8,
              ),
              Text('Copy Selected Definition'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.copy),
              SizedBox(
                width: 8,
              ),
              Text('Copy Root and Derivatives'),
            ],
          ),
        ),
      ],
      context: context,
    );
    
    switch (choice) {
      case 0:
        _copySingleDefinition(context, definitionList, index);
        break;
      case 1:
        _copyRootAndDerivatives(context, definitionList, index);
        break;
      default:
    }
  }

  static void _copySingleDefinition(
    BuildContext context,
    DefinitionProvider definitionList,
    int index,
  ) {
    Clipboard.setData(ClipboardData(
      text: parse(parse(definitionList.definition[index - 1]).body!.text)
          .documentElement!
          .text,
    ));
    
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied"),
      ),
    );
  }

  static void _copyRootAndDerivatives(
    BuildContext context,
    DefinitionProvider definitionList,
    int index,
  ) {
    String text = '';
    
    // Copy backwards from current index to root
    for (var i = index - 1; i >= 0; i--) {
      text = '${definitionList.definition[i]!}\n-*-*-*-*-*-*-*-*-*-\n$text';
      if (definitionList.isRoot[i] == 1) break;
    }
    
    // Copy forwards from current index
    for (var i = index; i < definitionList.definition.length; i++) {
      if (definitionList.isRoot[i] == 1) break;
      text = '$text${definitionList.definition[i]!}\n-*-*-*-*-*-*-*-*-*-\n';
    }
    
    Clipboard.setData(ClipboardData(
      text: parse(parse(text).body!.text).documentElement!.text,
    ));
    
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied"),
      ),
    );
  }
}
