import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'browse.dart';

const String title = "Favorites";

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>>? _favData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final favorites = await databaseObject.getFavorites();

      if (mounted) {
        setState(() {
          // _favData = favorites;
          _favData = List<Map<String, dynamic>>.from(favorites);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeFavorite(int index) async {
    if (_favData == null || index >= _favData!.length) return;

    final item = _favData![index];
    final id = item['id'];

    if (id == null) return;

    try {
      databaseObject.toggleFavorites(id as int, 0);

      if (mounted) {
        setState(() {
          _favData!.removeAt(index);
        });
      }
    } catch (e) {
      // handle error - show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove favorite: $e')),
        );
      }
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      textScaler: const TextScaler.linear(2.0),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.heart_broken,
          size: 72,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Text(
          'Favorite some words by selecting ❤️ icon',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFavoriteItem(BuildContext context, int index) {
    final item = _favData![index];
    final word = item['word']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: ListTile(
        onTap: word.isNotEmpty
            ? () async {
                await buildDefinitionAlert(context, word);
              }
            : null,
        leading: Text(
          '${index + 1}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.4),
              ),
        ),
        title: Text(
          word,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever),
          tooltip: 'Remove from favorites',
          onPressed: () => _removeFavorite(index),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _favData!.length,
      itemBuilder: (context, index) => _buildFavoriteItem(context, index),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading favorites',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFavorites,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_favData == null || _favData!.isEmpty) {
      return Expanded(
        child: Center(
          child: _buildEmptyState(context),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildFavoritesList(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(context),
            const SizedBox(height: 16),
            _buildContent(context),
          ],
        ),
      ),
    );
  }
}
