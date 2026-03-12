import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'package:example_flutter/data/sources/itunes_remote_source.dart';
import 'package:example_flutter/data/sources/favorites_local_source.dart';
import 'package:example_flutter/data/sources/preferences_local_source.dart';
import 'package:example_flutter/data/repositories/music_repository.dart';
import 'package:example_flutter/data/repositories/favorites_repository.dart';
import 'package:example_flutter/data/repositories/settings_repository.dart';

@GenerateMocks([
  // HTTP
  http.Client,
  // Data sources
  ItunesRemoteSource,
  FavoritesLocalSource,
  PreferencesLocalSource,
  // Repositories
  MusicRepository,
  FavoritesRepository,
  SettingsRepository,
])
void main() {}
