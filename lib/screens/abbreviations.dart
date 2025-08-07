import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

Scaffold abbreviationsView(BuildContext context, String title,
    List<String> abbreviations, List<String> fullForms) {
  final appbar = AppBar(
    toolbarHeight: 56,
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
    shadowColor: Colors.grey,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
    ),
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    iconTheme: Theme.of(context).iconTheme,
  );
  final drawer = CommonDrawer(currentScreen: title);

  return Scaffold(
    appBar: appbar,
    drawer: drawer,
    body: ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      itemCount: abbreviations.length,
      itemBuilder: (context, index) {
        if (fullForms[index] == "") {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              abbreviations[index],
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.grey,
                    fontSize:
                        Theme.of(context).textTheme.bodyLarge!.fontSize! * 2,
                  ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25,
                  child: SelectableText(abbreviations[index],
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: SelectableText(fullForms[index],
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}

class Abbreviations extends StatelessWidget {
  final String title;
  final List<String> abbreviations;
  final List<String> fullForms;
  const Abbreviations({
    super.key,
    required this.title,
    required this.abbreviations,
    required this.fullForms,
  });

  @override
  Widget build(BuildContext context) {
    return abbreviationsView(context, title, abbreviations, fullForms);
  }
}
