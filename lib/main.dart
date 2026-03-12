import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/database/database_helper.dart';
import 'data/repositories/favorites_repository.dart';
import 'data/repositories/music_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'data/sources/favorites_local_source.dart';
import 'data/sources/preferences_local_source.dart';
import 'data/sources/spotify_remote_source.dart';
import 'providers/home_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file (bundled as asset); ignore if missing (e.g. CI with --dart-define)
  await dotenv.load(fileName: '.env', mergeWith: {}).catchError((_) {});

  // Initialize SharedPreferences before runApp
  final prefs = await SharedPreferences.getInstance();

  // Data sources
  final prefsSource = PreferencesLocalSource(prefs);
  final dbHelper = DatabaseHelper();
  final spotifySource = SpotifyRemoteSource();
  final favoritesSource = FavoritesLocalSource(dbHelper);

  // Repositories
  final settingsRepo = SettingsRepository(prefsSource);
  final musicRepo = MusicRepository(spotifySource);
  final favoritesRepo = FavoritesRepository(favoritesSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider(settingsRepo)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(settingsRepo)),
        ChangeNotifierProvider(create: (_) => HomeProvider(musicRepo)),
        Provider.value(value: musicRepo),
        Provider.value(value: favoritesRepo),
      ],
      child: const App(),
    ),
  );
}
