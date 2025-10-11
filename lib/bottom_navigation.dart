import 'package:Xkart/util/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:Xkart/view/add_to_cart_screen/view/add_to_cart_screen.dart';
import 'package:Xkart/view/events_screen/events_screens.dart';
import 'package:Xkart/view/home_screen/home_screen.dart';
import 'package:Xkart/view/profile_screen/profile_screen.dart';

/// Controller to manage the selected tab
class NavController extends GetxController {
  final index = 0.obs;
  void setIndex(int i) => index.value = i;

  // Your actual pages
  final pages = const <Widget>[
    HomeScreen(),
    EventsScreens(),
    AddToCartScreen(),
    ProfileScreen(),
  ];
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(NavController());

    return Scaffold(
      body: Obx(() => c.pages[c.index.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0),
              width: 1,
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20), // 👈 Rounded top corners
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20), // 👈 Same rounding here too
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: c.index.value,
              onTap: c.setIndex,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house),

                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.calendarDays),

                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cartShopping),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.user),

                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
