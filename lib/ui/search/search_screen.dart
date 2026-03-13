import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/album.dart';
import '../../providers/search_provider.dart';
import '../../routes/route_names.dart';
import '../../ui/widgets/error_view.dart';
import '../../ui/widgets/loading_view.dart';
import 'search_result_tile.dart';

/// Search screen with animated search bar and staggered fade-in results.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final _SearchControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _SearchControllers.create();
    _controllers.focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  void _onSubmit(String query) {
    if (query.trim().isNotEmpty) {
      context.read<SearchProvider>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return SizeTransition(
              sizeFactor: AlwaysStoppedAnimation(value),
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: child,
            );
          },
          child: TextField(
            controller: _controllers.search,
            focusNode: _controllers.focusNode,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controllers.search.clear();
                  context.read<SearchProvider>().clear();
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmit,
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingView();
          }

          if (provider.errorMessage != null) {
            return ErrorView(
              message: provider.errorMessage!,
              onRetry: () => _onSubmit(_controllers.search.text),
            );
          }

          if (!provider.hasSearched) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.searchHint,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          if (provider.isEmpty) {
            return Center(
              child: Text(
                l10n.searchNoResults,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
            );
          }

          return _StaggeredResultsList(
            albums: provider.results,
            onAlbumTap: (album) =>
                context.push(RouteNames.detailPath(album.id), extra: album),
          );
        },
      ),
    );
  }
}

/// Holds controllers for [SearchScreen]. Owns their lifecycle.
///
/// Accepts injected [search] and [focusNode] — callers are responsible
/// for passing in the instances (dependency injection).
class _SearchControllers {
  final TextEditingController search;
  final FocusNode focusNode;

  _SearchControllers({required this.search, required this.focusNode});

  /// Factory that creates the controllers — kept here as the single
  /// creation point, separate from any widget/state method.
  static _SearchControllers create() => _SearchControllers(
    search: TextEditingController(),
    focusNode: FocusNode(),
  );

  void dispose() {
    search.dispose();
    focusNode.dispose();
  }
}

/// ListView with staggered fade-in animation per result tile.
///
/// Each item uses its own [TweenAnimationBuilder] — no [AnimationController]
/// required.
class _StaggeredResultsList extends StatelessWidget {
  final List<Album> albums;
  final void Function(Album album) onAlbumTap;

  const _StaggeredResultsList({required this.albums, required this.onAlbumTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return TweenAnimationBuilder<double>(
          key: ValueKey(album.id),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + index * 50),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return SearchResultTile(
              album: album,
              animation: AlwaysStoppedAnimation(value),
              onTap: () => onAlbumTap(album),
            );
          },
        );
      },
    );
  }
}
