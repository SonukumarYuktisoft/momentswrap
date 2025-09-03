import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:momentswrap/controllers/auth_controller/login_controller.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/util/common/coustom_curve.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_images_string.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/constants/app_text_strings.dart';
import 'package:momentswrap/util/common/widgets/app_widgets.dart';
import 'package:momentswrap/util/constants/app_text_theme.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:momentswrap/util/validator/app_validator.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget builds the login screen UI.
    // final LoginController loginController = Get.put(LoginController());
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: CustomCurve(),
                  child: Container(
                    height: HelperFunctions.screenHeight() * 0.4,
                    width: double.infinity,
                    color: AppColors.primaryColor,
                    child: // Logo
                    Stack(
                      children: [
                        Positioned(
                          top: 50,
                          left: 100,
                          child: Image.asset(
                            AppImagesString.appLogo,
                            height: 200,
                            width: 200,
                          ),
                          // child: const Text(
                          //   "Moments Wrap",
                          //   style: TextStyle(
                          //     fontSize: 42,
                          //     fontWeight: FontWeight.bold,
                          //     color: Color(0xFFE60023),
                          //   ),
                        ),

                        // Subtitle
                        Positioned(
                          top: 255,
                          left: 50,
                          child: const Text(
                            "Log in or Sign up to continue into",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              // color: Color(0xFFE60023),
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: AppSizes.defaultSpacing),

            // Login Form
            Form(
              key: controller.loginFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.defaultSpacing,
                ),
                child: Column(
                  children: [
                    // const SizedBox(height: 10),
                    // Text(
                    //   'Welcome Back',
                    //   style: Theme.of(context).textTheme.headlineMedium,
                    // ),
                    // const SizedBox(height: 5),
                    // Text(
                    //   'Login your account',
                    //   style: Theme.of(context).textTheme.bodyMedium,
                    // ),
                    const SizedBox(height: 20),

                    AppWidgets.buildTextFormField(
                      label: 'Email',
                      validator: AppValidator.validateEmail,
                      prefixIcon: Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: AppSizes.spaceBtwInputField),
                    Obx(() {
                      return AppWidgets.buildTextFormField(
                        label: 'Password',
                        validator: AppValidator.validatePassword,
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.toggle.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.changeToggle,
                        ),
                        obscureText: controller.toggle.value,
                        keyboardType: TextInputType.visiblePassword,
                        controller: controller.passwordController,
                      );
                    }),
                  ],
                ),
              ),
            ),

            /// login button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgotPassword);
                  },
                  child: const Text('Forgot Password'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return Expanded(
                    child: AppWidgets.buildButton(
                      isLoading: controller.isLoading.value,
                      title: 'Login',
                      onPressed: () => controller.login(),
                    ),
                  );
                }),
              ],
            ),

            /// Sign Up
            const SizedBox(height: AppSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(
                  child: AppWidgets.buildButton(
                    title: 'Create Account',
                    onPressed: () {
                      Get.toNamed(AppRoutes.signUp);
                    },
                  ),
                ),
              ],
            ),
            // const SizedBox(height: AppSizes.spaceBtwItems),
            //    // OR divider
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Expanded(
            //           child: Divider(
            //             indent: 40,
            //             endIndent: 10,
            //             color: Colors.white,
            //           ),
            //         ),
            //         Text("OR",style: TextStyle(color: Colors.white,fontSize: 18),),
            //         Expanded(
            //           child: Divider(
            //             indent: 10,
            //             endIndent: 40,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ],
            //     ),

            // const SizedBox(height: AppSizes.spaceBtwItems),

            //     // Social buttons
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         CircleAvatar(
            //           radius: 28,
            //           backgroundColor: Colors.white,
            //           child: IconButton(onPressed: () {}, icon:  Icon(
            //             Icons.g_mobiledata,
            //             size: 40,
            //             color: Colors.red,
            //           ),)
            //         ),
            //         const SizedBox(width: 30),
            //         CircleAvatar(
            //           radius: 28,
            //           backgroundColor: Colors.white,
            //           child: IconButton(onPressed: () {

            //           }, icon: Icon(
            //             Icons.facebook,
            //             size: 32,
            //             color: Colors.blue,
            //           ),)
            //         ),
            //       ],
            //     )
          ],
        ),
      ),
    );
  }
}
