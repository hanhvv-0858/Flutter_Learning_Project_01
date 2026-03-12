import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/home_provider.dart';
import '../../routes/route_names.dart';
import '../../ui/widgets/error_view.dart';
import '../../ui/widgets/loading_view.dart';
import 'album_card.dart';

/// Home screen displaying top albums from iTunes.
///
/// Shows tri-state UI: loading → data (ListView of AlbumCard) → error.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data on first load
    final provider = context.read<HomeProvider>();
    Future.microtask(() => provider.fetchNewReleases());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(RouteNames.search),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingView();
          }

          if (provider.errorMessage != null) {
            return ErrorView(
              message: provider.errorMessage!,
              onRetry: provider.retry,
            );
          }

          if (provider.albums.isEmpty) {
            return Center(child: Text(l10n.searchNoResults));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchNewReleases,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.albums.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final album = provider.albums[index];
                return AlbumCard(
                  album: album,
                  onTap: () => context.push(
                    RouteNames.detailPath(album.id),
                    extra: album,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
