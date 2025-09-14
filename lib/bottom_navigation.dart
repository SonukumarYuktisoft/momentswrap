import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/view/add_to_cart_screen/add_to_cart_screen.dart';
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
        () => BottomNavigationBar(
          currentIndex: c.index.value,
          onTap: c.setIndex,
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
