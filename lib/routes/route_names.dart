/// Named route path constants for GoRouter.
class RouteNames {
  RouteNames._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String detail = '/detail/:id';
  static const String search = '/search';

  /// Build detail path with a specific album ID.
  static String detailPath(String id) => '/detail/$id';
}
