import 'package:flutter/material.dart';

import '../../models/track.dart';

/// Displays a single track row: number, name, and formatted duration.
class TrackListTile extends StatelessWidget {
  final Track track;

  const TrackListTile({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 28,
        child: Center(
          child: Text(
            '${track.trackNumber}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ),
      ),
      title: Text(track.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        track.formattedDuration,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
      ),
    );
  }
}
