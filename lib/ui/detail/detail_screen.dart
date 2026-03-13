import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/album.dart';
import '../../providers/detail_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../ui/widgets/error_view.dart';
import '../../ui/widgets/loading_view.dart';
import 'track_list_tile.dart';

/// Detail screen showing album info, track list, and favorite toggle.
///
/// Receives [Album] via GoRouter `extra`. Loads tracks on init.
class DetailScreen extends StatefulWidget {
  final Album album;

  const DetailScreen({super.key, required this.album});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<DetailProvider>();
    Future.microtask(() {
      provider.loadTracks(widget.album.id);
      provider.checkFavorite(widget.album.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.detailTitle)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Album cover art — large
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: widget.album.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, _, _) =>
                    const Icon(Icons.album, size: 80, color: Colors.grey),
              ),
            ),

            // Album info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Album type badge
                  Chip(
                    label: Text(
                      widget.album.albumType.toUpperCase(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(height: 8),

                  // Album name
                  Text(
                    widget.album.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Artist
                  Text(
                    widget.album.artistName,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),

                  // Release date
                  if (widget.album.releaseDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.detailReleaseDate(widget.album.releaseDate!),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(),

            // Favorite button
            Consumer<DetailProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: provider.isFavorite
                        ? OutlinedButton.icon(
                            key: const ValueKey('remove'),
                            onPressed: () async {
                              await provider.toggleFavorite(widget.album);
                              if (!context.mounted) return;
                              context.read<FavoritesProvider>().loadFavorites();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.detailRemoved)),
                              );
                            },
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            label: Text(l10n.detailRemoveFromFavorites),
                          )
                        : ElevatedButton.icon(
                            key: const ValueKey('save'),
                            onPressed: () async {
                              await provider.toggleFavorite(widget.album);
                              if (!context.mounted) return;
                              context.read<FavoritesProvider>().loadFavorites();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.detailSaved)),
                              );
                            },
                            icon: const Icon(Icons.favorite_border),
                            label: Text(l10n.detailSaveToFavorites),
                          ),
                  ),
                );
              },
            ),

            const Divider(),

            // Tracks header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                l10n.detailTracks,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            // Track list
            Consumer<DetailProvider>(
              builder: (context, provider, _) {
                if (provider.isLoadingTracks) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: LoadingView(),
                  );
                }
                if (provider.tracksError != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorView(
                      message: provider.tracksError!,
                      onRetry: () => provider.loadTracks(widget.album.id),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.tracks.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return TrackListTile(track: provider.tracks[index]);
                  },
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
