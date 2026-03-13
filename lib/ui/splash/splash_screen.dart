import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_config.dart';
import '../../routes/route_names.dart';

/// Animated splash screen with fade-in + scale on an app logo.
///
/// Uses [TweenAnimationBuilder] so no [AnimationController] is required.
/// After the animation completes, navigates via GoRouter redirect logic.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateNext(BuildContext context) {
    if (context.mounted) context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: AppConfig.splashDuration,
          onEnd: () => _navigateNext(context),
          builder: (context, value, child) {
            return Opacity(
              opacity: Curves.easeIn.transform(value),
              child: Transform.scale(
                scale: Curves.easeOutBack.transform(value).clamp(0.0, 2.0),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 120,
                height: 120,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.album,
                  size: 120,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Music Explorer',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
