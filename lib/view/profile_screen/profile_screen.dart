import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momentswrap/controllers/profile_controller/profile_controller.dart';
import 'package:momentswrap/util/constants/app_sizes.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F6), // soft pink background
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: const Icon(Icons.menu, color: Colors.black),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search, color: Colors.black),
      //       onPressed: () {},
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
      //       onPressed: () {},
      //     ),
      //     const Padding(
      //       padding: EdgeInsets.only(right: 12),
      //       child: CircleAvatar(
      //         radius: 16,
      //         backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
      //       ),
      //     ),
      //   ],
      //   title: const Text(
      //     "Profile",
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: AppSizes.appBarHeight),
          child: Column(
            children: [
              // Profile picture
              // const CircleAvatar(
              //   radius: 50,
              //   backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
              // ),
              Obx(() {
                return GestureDetector(
                  onTap: () => controller.pickImage(ImageSource.gallery),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : null,
                    child: controller.profileImage.value == null
                        ? Icon(Icons.person, size: 60)
                        : null,
                  ),
                );
              }),

              const SizedBox(height: 12),
              Obx(
                () => Text(
                  controller.fullName.value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 6),
              Obx(
                () => Text(
                  controller.email.value,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 20),

              // Rounded card with profile options
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // _buildProfileItem(icon: Icons.favorite, title: "Wishlist", onTap: () {}),
                    // _buildProfileItem(icon: Icons.shopping_bag, title: "My Orders", onTap: () {}),
                    // _buildProfileItem(icon: Icons.location_on, title: "Shipping Address", onTap: () {}),
                    // _buildProfileItem(icon: Icons.settings, title: "Settings", onTap: () {}),
                    // _buildProfileItem(icon: Icons.logout, title: "Logout", color: Colors.red, onTap: () {

                    //   controller.logOut();
                    // }),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.pink),
                      title: const Text(
                        "Log Out",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        controller.logOut();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    IconData? icon,
    required String title,
    Color? color,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.pink),

      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
