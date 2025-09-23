import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/view/onboarding_screens/onboarding_screens.dart';
import 'package:Xkart/view/reviews_screen/my_reviews_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:Xkart/binding/auth_binding/auth_binding.dart';
import 'package:Xkart/binding/cart_binding/cart_binding.dart';
import 'package:Xkart/binding/home_binding/home_binding.dart';
import 'package:Xkart/binding/profile_binding/profile_binding.dart';
import 'package:Xkart/bottom_navigation.dart';
import 'package:Xkart/view/add_to_cart_screen/add_to_cart_screen.dart';
import 'package:Xkart/view/auth/forget_screen.dart';
import 'package:Xkart/view/auth/login_screen.dart';
import 'package:Xkart/view/auth/signup_screen.dart';
import 'package:Xkart/view/home_screen/home_screen.dart';
import 'package:Xkart/view/notifications_screen/notifications_screen.dart';
import 'package:Xkart/view/order_screen/orders_screen.dart';
import 'package:Xkart/view/profile_screen/edit_profile_screen.dart';
import 'package:Xkart/view/profile_screen/profile_screen.dart';
import 'package:Xkart/view/search_screens/search_screen.dart';

class AppPages {
  static const initial = AppRoutes.bottomNavigation;

  // Define the routes for the application
  // Each route is defined using GetPage, which includes the name, page builder, and
  static final routes = [
    ///splashScreen
    /// Splash_Screen
    // GetPage(
    //   name: AppRoutes.splashScreen,
    //   page: () => const SplashScreen(),
    //   transition: Transition.native,
    // ),

    /// Onboarding_Screens
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreens(),
      transition: Transition.fadeIn,
    ),

    ///------------------------- Auth_Screens---------------///////

    /// Login Screen
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: AuthBinding(),
    ),

    /// Sign Up Screen
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => SignupScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: AuthBinding(),
    ),

    /// Forgot Password Screen
    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => ForgetScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: AuthBinding(),
    ),

    /// Bottom_Navigation
    GetPage(
      name: AppRoutes.bottomNavigation,
      page: () => BottomNavigation(),

      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// Notifications
    GetPage(
      name: AppRoutes.notificationsScreen,
      page: () => NotificationsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// Search Screen
    GetPage(
      name: AppRoutes.searchScreen,
      page: () => SearchAndFiltersBar(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// Home_Screen
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: HomeBinding(),
    ),

    /// Cart Screen
    GetPage(
      name: AppRoutes.cartScreen,
      page: () => AddToCartScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: CartBinding(),
    ),

    /// Order Details Screen
    GetPage(
      name: AppRoutes.orderScreen,
      page: () => const OrdersScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    //  /// Order Details Screen
    //     GetPage(
    //       name: AppRoutes.orderDetailsScreen,
    //       page: () => OrderDetailsScreen(),
    //       transition: Transition.fadeIn,
    //       transitionDuration: const Duration(milliseconds: 300),
    //     ),
    /// Profile Screen
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: ProfileBinding(),
    ),

    ///EditProfileScreen
    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () => const EditProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      binding: ProfileBinding(),
    ),

    //reviews_screen
    GetPage(
      name: AppRoutes.myReviewsScreen,
      page: () => MyReviewsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      // binding: ProfileBinding(),
    ),

    //    GetPage(
    //   name: AppRoutes.aiAssistant,
    //   page: () => AIAssistantScreen(),
    //   transition: Transition.cupertino,
    // ),
  ];
}
