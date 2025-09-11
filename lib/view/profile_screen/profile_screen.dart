import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/controllers/profile_controller/profile_controller.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/util/common/auth_utils.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.backgroundColor,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading your profile...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          // onRefresh: () => controller.getCustomerProfile(),
          onRefresh: () => controller.checkLoginAndFetchData(),
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.backgroundColor,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Modern Header with Profile
                  Container(
                    // padding: EdgeInsets.only(
                    //   top: AppSizes.appBarHeight + 20,
                    //   left: 100,
                    //   right: 100,
                    //   bottom: 30,
                    // ),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top + 20,
                      bottom: 30,
                    ),

                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/bgimg.png"),
                        fit: BoxFit.none,
                        // colorFilter: ColorFilter.mode(
                        //   AppColors.primaryColor.withOpacity(
                        //     0.3,
                        //   ), // overlay color
                        //   BlendMode
                        //       .darken, // ya phir softLight / overlay try kar sakte ho
                        // ),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile Picture with Modern Styling
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.accentColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondaryColor.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: AppColors.backgroundColor,
                                backgroundImage:
                                    controller.profileImage.value != null
                                    ? FileImage(controller.profileImage.value!)
                                    : null,
                                child: controller.profileImage.value == null
                                    ? Icon(
                                        Icons.person_outline,
                                        size: 60,
                                        color: AppColors.primaryColor,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.secondaryGradient,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accentColor,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.secondaryColor
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.accentColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // User Info with Modern Typography
                        Text(
                          controller.fullName.isNotEmpty
                              ? controller.fullName
                              : 'Welcome User',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentColor,
                          ),
                        ),

                        const SizedBox(height: 8),

                        if (controller.email.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              controller.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.accentColor,
                              ),
                            ),
                          ),

                        const SizedBox(height: 6),

                        if (controller.phoneNumber.isNotEmpty)
                          Text(
                            controller.phoneNumber,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.accentColor.withOpacity(0.8),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Modern Menu Options
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Quick Actions Card
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildModernProfileItem(
                                icon: Icons.edit_outlined,
                                title: "Edit Profile",
                                subtitle: "Update your information",
                                color: AppColors.infoColor,
                                onTap: () => AuthUtils.runIfLoggedIn(() {
                                  Get.toNamed(AppRoutes.editProfileScreen);
                                }),
                              ),

                              _buildModernDivider(),

                              _buildModernProfileItem(
                                icon: Icons.shopping_bag_outlined,
                                title: "My Orders",
                                subtitle: "Track your purchases",
                                color: AppColors.secondaryColor,
                                onTap: () => AuthUtils.runIfLoggedIn(() {
                                  Get.toNamed(AppRoutes.orderScreen);
                                }),
                              ),

                              _buildModernDivider(),

                              _buildModernProfileItem(
                                icon: Icons.refresh_outlined,
                                title: "Refresh Profile",
                                subtitle: "Update profile data",
                                color: AppColors.successColor,
                                onTap: () => AuthUtils.runIfLoggedIn(() {
                                  controller.getCustomerProfile();
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Danger Zone Card
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.cardGradient,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.errorColor.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.errorColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_outlined,
                                      color: AppColors.errorColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Danger Zone',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Obx(
                                () => _buildModernProfileItem(
                                  icon: Icons.delete_forever_outlined,
                                  title: "Delete Account",
                                  subtitle: "Permanently remove your account",
                                  color: AppColors.errorColor,
                                  onTap: () => AuthUtils.runIfLoggedIn(() {
                                    controller.isDeleting.value
                                        ? null
                                        : controller.showDeleteConfirmation();
                                  }),
                                  trailing: controller.isDeleting.value
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  AppColors.errorColor,
                                                ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),

                              _buildModernDivider(),

                              _buildModernProfileItem(
                                icon: Icons.logout_outlined,
                                title: "Log Out",
                                subtitle: "Sign out of your account",
                                color: AppColors.warningColor,
                                onTap: () => AuthUtils.runIfLoggedIn(() {
                                  _showModernLogoutConfirmation();
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Debug Info (remove in production)
                        if (controller.profile.value != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.secondaryColor.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppColors.secondaryColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Profile Debug Info',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ID: ${controller.userId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'First: ${controller.firstName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'Last: ${controller.lastName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildModernProfileItem({
    IconData? icon,
    required String title,
    String? subtitle,
    Color? color,
    void Function()? onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (color ?? AppColors.primaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color ?? AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: onTap == null
                            ? AppColors.textSecondary
                            : AppColors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  (onTap != null
                      ? Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.primaryColor.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  void _showModernLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout_outlined,
                color: AppColors.warningColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Log Out',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.warningColor,
                  AppColors.warningColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Get.back();
                controller.logOut();
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
