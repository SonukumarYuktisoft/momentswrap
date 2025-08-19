class AppRoutes {




  /// Onboarding_Screens
  static const String onboarding = '/onboarding';

  /// Auth_Screen
  static const String login = '/login';
  static const String signUp = '/sign-up';
  /// Forgot Password
  static const String forgotPassword = '/forgot-password';



  ///bottom_navigation
  static const String bottomNavigation = '/bottom-navigation';

  /// Home_Screen
  static const String home = '/home-screen';

  /// Cart Screen
  static const String cart = '/cart-screen';

  /// Profile Screen
  static const String profile = '/profile-screen';

  /// Not Found
  static const String notFound = '/not-found';

  // all routes
  static final List<String> allRoutes = [
    login,
    signUp,
    bottomNavigation,
    home,
    notFound,
  ];
}