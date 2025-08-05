import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'classes/definition_provider.dart';
import 'classes/search_suggestions_provider.dart';
import 'classes/theme_model.dart';
import 'service_locator.dart';

import './routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator().then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeModel>(
            create: (BuildContext context) => ThemeModel(),
          ),
          ChangeNotifierProvider<SearchSuggestionsProvider>(
            create: (_) => SearchSuggestionsProvider(),
          ),
          ChangeNotifierProvider<DefinitionProvider>(
            create: (_) => DefinitionProvider(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeModel>().currentTheme;

    return MaterialApp(
        title: "Lane's Lexicon",
        theme: theme,
        initialRoute: '/search',
        routes: routes);
  }
}
