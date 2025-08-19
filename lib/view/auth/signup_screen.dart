import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:momentswrap/controllers/auth_controller/signup_controller.dart';
import 'package:momentswrap/util/common/widgets/app_widgets.dart';
import 'package:momentswrap/util/constants/app_images_string.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/constants/app_text_theme.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:momentswrap/util/validator/app_validator.dart';

class SignupScreen extends GetView<SignupController> {
  @override
  Widget build(BuildContext context) {
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
                      height: HelperFunctions.screenHeight() * 0.2,
                      width: HelperFunctions.screenHeight() * 0.2,
                      fit: BoxFit.cover,
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Signup',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Signup to your account',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.defaultSpacing),

                // Signup Form
                Form(
                  key: controller.signupFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppWidgets.buildTextFormField(
                              label: 'First Name',
                              validator: AppValidator.validateFirstName,
                              prefixIcon: Icon(Icons.person_outline),
                              keyboardType: TextInputType.name,
                              controller: controller.firstNameController,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceBtwInputField),
                          Expanded(
                            child: AppWidgets.buildTextFormField(
                              label: 'Last Name',
                              validator: AppValidator.validateLastName,
                              prefixIcon: Icon(Icons.person_outline),
                              keyboardType: TextInputType.name,
                              controller: controller.lastNameController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceBtwInputField),
                       AppWidgets.buildTextFormField(
                        label: 'Phone',
                        validator: AppValidator.validatePhoneNumber,
                        prefixIcon: Icon(Icons.phone_outlined),
                        keyboardType: TextInputType.phone,
                        controller: controller.phoneController,
                      ),

                      const SizedBox(height: AppSizes.spaceBtwInputField),

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
                SizedBox(height: AppSizes.spaceBtwItems),
                Row(
                  children: [
                    Obx(() {
                      return AppWidgets.buildButton(
                        isLoading: controller.isLoading.value,
                        title: 'Signup',
                        onPressed: () => controller.signup(),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
