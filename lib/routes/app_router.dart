import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/onboarding_provider.dart';
import '../routes/route_names.dart';
import '../ui/home/home_screen.dart';
import '../ui/onboarding/onboarding_screen.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/widgets/bottom_nav_shell.dart';

// Placeholder screens — replaced in later phases
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

/// Application router using GoRouter with ShellRoute for bottom navigation.
GoRouter createRouter(OnboardingProvider onboardingProvider) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final isSplash = state.matchedLocation == RouteNames.splash;
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;

      // After splash, redirect based on onboarding status
      if (!isSplash && !isOnboarding && !onboardingProvider.isCompleted) {
        return RouteNames.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.favorites,
                builder: (context, state) =>
                    const _PlaceholderScreen('Favorites'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settings,
                builder: (context, state) =>
                    const _PlaceholderScreen('Settings'),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.detail,
        builder: (context, state) => const _PlaceholderScreen('Detail'),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) => const _PlaceholderScreen('Search'),
      ),
    ],
  );
}
