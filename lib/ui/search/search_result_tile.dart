import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/album.dart';

/// A single search result row with album art, name, and artist.
///
/// Wrapped in a [FadeTransition] when animated via parent.
class SearchResultTile extends StatelessWidget {
  final Album album;
  final VoidCallback? onTap;
  final Animation<double>? animation;

  const SearchResultTile({
    super.key,
    required this.album,
    this.onTap,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final child = ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: album.imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => const Icon(Icons.album, size: 48),
        ),
      ),
      title: Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        album.artistName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );

    if (animation != null) {
      return FadeTransition(opacity: animation!, child: child);
    }
    return child;
  }
}
