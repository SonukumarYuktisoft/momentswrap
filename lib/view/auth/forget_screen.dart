import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:momentswrap/controllers/auth_controller/forget_controller.dart';
import 'package:momentswrap/util/common/coustom_curve.dart';
import 'package:momentswrap/util/common/widgets/app_widgets.dart';
import 'package:momentswrap/util/constants/app_images_string.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';
import 'package:momentswrap/util/constants/app_text_theme.dart';
import 'package:momentswrap/util/helpers/helper_functions.dart';
import 'package:momentswrap/util/validator/app_validator.dart';

class ForgetScreen extends GetView<ForgetController> {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE60023),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                //header
                
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        //header
        ClipPath(
          clipper: CustomCurve(),
          child: Container(
            height: HelperFunctions.screenHeight() * 0.4,
            width: double.infinity,
            color: Colors.white,
            child: // Logo
          Stack(
              children: [
                Positioned(
                  top: 100,
                  left: 50,
                  child: const Text(
                    "Moments Wrap",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE60023),
                    ),
                  ),
                ),
          
                // Subtitle
                Positioned(
                  top: 160,
                  left: 50,
                  child: const Text(
                    "Log in or Sign up to continue into \n access your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFE60023),
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
            const SizedBox(height: AppSizes.defaultSpacing),
              
            // Forget Password Form
            Form(
              key: controller.forgetFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                   horizontal: AppSizes.defaultSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppWidgets.buildTextFormField(
                      label: 'Email',
                      validator: AppValidator.validateEmail,
                      prefixIcon: Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailController,
                    ),
                
                    /// Submit button
                    SizedBox(height: AppSizes.defaultSpacing),
                    Row(
                      children: [
                        Obx(() {
                          return Expanded(
                            child: AppWidgets.buildButton(
                              isLoading: controller.isLoading.value,
                              title: 'Submit',
                              onPressed: () => controller.login(),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
