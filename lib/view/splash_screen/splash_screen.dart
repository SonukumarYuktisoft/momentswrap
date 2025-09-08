// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:momentswrap/controllers/auth_controller/login_controller.dart';
// import 'package:momentswrap/routes/app_routes.dart';
// import 'package:momentswrap/services/shared_preferences_services.dart';
// import 'package:momentswrap/util/constants/app_colors.dart';
// import 'package:momentswrap/util/constants/app_images_string.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _handleAppFlow();
//   }

//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 8000),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.elasticOut,
//     ));

//     _animationController.forward();
//   }

//   /// Handle complete app flow logic
//   Future<void> _handleAppFlow() async {
//     try {
//       // Wait for animation to complete
//       await Future.delayed(Duration(milliseconds: 2500));

//       // Get auth controller
//       final authController = Get.find<LoginController>();

//       // Check app state
//       final authStatus = await SharedPreferencesServices.getAuthStatus();
//       final isFirstTime = await SharedPreferencesServices.isFirstLaunch();

//       print('=== App Flow Debug ===');
//       print('Is First Time: $isFirstTime');
//       print('Auth Status: $authStatus');
//       print('=====================');

//       if (isFirstTime || !authStatus['onboardingCompleted']) {
//         // First time user - show onboarding
//         print('Navigating to: Onboarding');
//         Get.offAllNamed(AppRoutes.onboarding);
//       } else if (authStatus['isLoggedIn'] && authStatus['hasValidToken']) {
//         // Logged in user with valid token
//         print('Navigating to: Bottom Navigation (Logged In)');
//         authController.isGuestMode.value = false;
//         Get.offAllNamed(AppRoutes.bottomNavigation);
//       } else if (authStatus['isGuest']) {
//         // Guest user
//         print('Navigating to: Bottom Navigation (Guest Mode)');
//         authController.isGuestMode.value = true;
//         Get.offAllNamed(AppRoutes.bottomNavigation);
//       } else {
//         // No login, no guest mode - show login
//         print('Navigating to: Login Screen');
//         authController.isGuestMode.value = false;
//         Get.offAllNamed(AppRoutes.loginScreen);
//       }
//     } catch (e) {
//       print('Error in app flow: $e');
//       // Fallback to login screen
//       Get.offAllNamed(AppRoutes.loginScreen);
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.primaryColor,
//               AppColors.primaryColor.withOpacity(0.8),
//               AppColors.secondaryColor.withOpacity(0.2),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Animated Logo
//               AnimatedBuilder(
//                 animation: _animationController,
//                 builder: (context, child) {
//                   return FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Container(
//                         padding: EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(24),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 20,
//                               offset: Offset(0, 10),
//                             ),
//                           ],
//                         ),
//                         child: Image.asset(
//                           AppImagesString.appLogo,
//                           height: 120,
//                           width: 120,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               SizedBox(height: 40),

//               // App Name with Animation
//               AnimatedBuilder(
//                 animation: _fadeAnimation,
//                 builder: (context, child) {
//                   return FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Moments Wrap',
//                           style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 1.2,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Wrap Your Special Moments',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),

//               SizedBox(height: 60),

//               // Loading Indicator
//               AnimatedBuilder(
//                 animation: _fadeAnimation,
//                 builder: (context, child) {
//                   return FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           width: 40,
//                           height: 40,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 3,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Loading...',
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
