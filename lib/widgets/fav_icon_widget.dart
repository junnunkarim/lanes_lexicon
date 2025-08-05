import 'package:flutter/material.dart';
import '../../classes/definition_provider.dart';
import '../services/favorites_service.dart';

class FavIconWidget extends StatefulWidget {
  const FavIconWidget({super.key, this.definitionList, this.index});
  final DefinitionProvider? definitionList;
  final int? index;
  
  @override
  State<FavIconWidget> createState() => _FavIconWidgetState();
}

class _FavIconWidgetState extends State<FavIconWidget> {
  Color? favIconColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favIconColor = widget.definitionList!.favoriteFlag[widget.index! - 1] == 1
        ? Colors.red
        : Colors.grey;
        
    return IconButton(
      onPressed: () {
        FavoritesService.toggleFavorites(
          widget.definitionList!,
          widget.index!,
          context,
        );
        setState(() {
          favIconColor = favIconColor == Colors.red ? Colors.grey : Colors.red;
        });
      },
      icon: Icon(
        Icons.favorite,
        color: favIconColor,
      ),
    );
  }
}
