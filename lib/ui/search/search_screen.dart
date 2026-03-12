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

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  late final AnimationController _animController;
  late final Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _barAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    // Expand search bar on enter
    _animController.forward();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animController.dispose();
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
        title: AnimatedBuilder(
          animation: _barAnimation,
          builder: (context, child) {
            return SizeTransition(
              sizeFactor: _barAnimation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: child,
            );
          },
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
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
              onRetry: () => _onSubmit(_searchController.text),
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

/// ListView with staggered fade-in animation per result tile.
class _StaggeredResultsList extends StatefulWidget {
  final List<Album> albums;
  final void Function(Album album) onAlbumTap;

  const _StaggeredResultsList({required this.albums, required this.onAlbumTap});

  @override
  State<_StaggeredResultsList> createState() => _StaggeredResultsListState();
}

class _StaggeredResultsListState extends State<_StaggeredResultsList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + widget.albums.length * 50),
    );
    _staggerController.forward();
  }

  @override
  void didUpdateWidget(covariant _StaggeredResultsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.albums != widget.albums) {
      _staggerController.duration = Duration(
        milliseconds: 300 + widget.albums.length * 50,
      );
      _staggerController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.albums.length,
      itemBuilder: (context, index) {
        final begin = (index / widget.albums.length).clamp(0.0, 1.0);
        final end = ((index + 1) / widget.albums.length).clamp(0.0, 1.0);
        final animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(begin, end, curve: Curves.easeOut),
          ),
        );
        final album = widget.albums[index];
        return SearchResultTile(
          album: album,
          animation: animation,
          onTap: () => widget.onAlbumTap(album),
        );
      },
    );
  }
}
