import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:momentswrap/binding/auth_binding/auth_binding.dart';
import 'package:momentswrap/binding/cart_binding/cart_binding.dart';
import 'package:momentswrap/binding/home_binding/home_binding.dart';
import 'package:momentswrap/binding/profile_binding/profile_binding.dart';
import 'package:momentswrap/bottom_navigation.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/view/add_to_cart_screen/add_to_cart_screen.dart';
import 'package:momentswrap/view/auth/forget_screen.dart';
import 'package:momentswrap/view/auth/login_screen.dart';
import 'package:momentswrap/view/auth/signup_screen.dart';
import 'package:momentswrap/view/home_screen/home_screen.dart';
import 'package:momentswrap/view/onboarding_screens/onboarding_screens.dart';
import 'package:momentswrap/view/profile_screen/profile_screen.dart';

class AppPages {
  static const initial = AppRoutes.bottomNavigation;

  // Define the routes for the application
  // Each route is defined using GetPage, which includes the name, page builder, and
  static final routes = [



    /// Onboarding_Screens
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreens(),
      transition: Transition.fadeIn,
    ),

    ///------------------------- Auth_Screens---------------///////

    /// Login Screen
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
      binding: AuthBinding(),
    ),

    /// Sign Up Screen
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignupScreen(),
      transition: Transition.fadeIn,
      binding: AuthBinding(),
    ),

    /// Forgot Password Screen
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgetScreen(),
      transition: Transition.fadeIn,
      binding: AuthBinding(),
    ),

    /// Bottom_Navigation
    GetPage(
      name: AppRoutes.bottomNavigation,
      page: () =>  BottomNavigation(),
      transition: Transition.fadeIn,
    ),

    /// Home_Screen
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      binding: HomeBinding()
    ),

    /// Cart Screen
    GetPage(
      name: AppRoutes.cart,
      page: () => AddToCartScreen(),
      transition: Transition.fadeIn,
      binding: CartBinding(),
    ),

    /// Profile Screen
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
      binding: ProfileBinding(),
    ),
  ];
}
