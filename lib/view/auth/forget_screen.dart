import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:momentswrap/controllers/auth_controller/forget_controller.dart';
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
                    // Image.asset(
                    //   AppImagesString.loginImage,
                    //   height: HelperFunctions.screenHeight() * 0.2,
                    //   width: double.infinity,
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      'Forget Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Enter your email to reset password',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
                const SizedBox(height: AppSizes.defaultSpacing),

                // Forget Password Form
                Form(
                  key: controller.forgetFormKey,
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
                            return AppWidgets.buildButton(
                              isLoading: controller.isLoading.value,
                              title: 'Submit',
                              onPressed: () => controller.login(),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
