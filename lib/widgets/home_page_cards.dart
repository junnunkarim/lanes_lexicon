import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/definition_provider.dart';

class HomePageCards extends StatelessWidget {
  const HomePageCards({
    super.key,
    required this.imagePath,
    this.route,
    this.uri,
  });
  
  final String imagePath;
  final String? route;
  final Uri? uri;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        route != null
            ? Provider.of<DefinitionProvider>(context, listen: false)
                .updateSearchType(route!)
            : launchUrl(uri!, mode: LaunchMode.externalApplication);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
                image: AssetImage(imagePath), fit: BoxFit.cover),
          ),
          child: Card(
            elevation: 0,
            shadowColor: Theme.of(context).primaryColor,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
