import 'package:Xkart/util/common/success_screen.dart';
import 'package:Xkart/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

class AdvancedSuccessExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: "Account Created Successfully!",
      subtitle: "Welcome to our platform. You're all set to get started.",
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.green,
      iconSize: 120,
      animationDuration: Duration(milliseconds: 1000),
      displayDuration: Duration(seconds: 3),
      showProgressIndicator: true,
      backgroundGradient: [
        Colors.blue.shade50,
        Colors.white,
      ],
      messageStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
      onComplete: () {
        print("Success screen completed");
      },
      nextPage: HomeScreen(),
    );
  }
}
