import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:momentswrap/controllers/auth_controller/login_controller.dart';
import 'package:momentswrap/routes/app_routes.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppImagesString.loginImage,
                      height: HelperFunctions.screenHeight()*0.2,
                      width: double.infinity,
                      
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Login your account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.defaultSpacing),

                // Login Form
                Form(
                  key: controller.loginFormKey,
                  child: Column(
                    children: [
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
                /// login button
             
                Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    }, child: const Text('Forgot Password?'))
                  ],
                ),
                Row(
                  children: [
                    Obx(() {
                      return AppWidgets.buildButton(
                        isLoading: controller.isLoading.value,
                        title: 'Login',
                        onPressed: () => controller.login(),
                      );
                    }),
                  ],
                ),


/// Sign Up
                const SizedBox(height: AppSizes.spaceBtwItems),
                Row(
                  children: [
                    AppWidgets.buildOutlinedButton(title: 'Create Account', onPressed: () {
                      Get.toNamed(AppRoutes.signUp);
                    }),
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
