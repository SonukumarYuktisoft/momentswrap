import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Xkart/util/constants/app_sizes.dart';
import 'package:Xkart/util/helpers/helper_functions.dart';

class FullLoaderScreens extends StatelessWidget {
  final String animationPath;

  const FullLoaderScreens({super.key, required this.animationPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60, // background dark overlay
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Lottie.asset(
          animationPath,
          width: HelperFunctions.screenHeight() * 5,

          height: HelperFunctions.screenHeight() * 5,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
