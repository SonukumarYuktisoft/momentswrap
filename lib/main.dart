import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Xkart/pagetast.dart';
import 'package:Xkart/routes/app_pages.dart';
import 'package:Xkart/routes/app_routes.dart';
import 'package:Xkart/test.dart';
import 'package:Xkart/util/common/full_loader_screens.dart';
import 'package:Xkart/util/not_found_screen/not_fonud_screen.dart';
import 'package:Xkart/util/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Xkart',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,

      // GetX Navigation
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: AppRoutes.notFoundScreen,
        page: () => NotFoundScreen(),
      ),
      // home: AdvancedSuccessExample(),

      // home: FullLoaderScreens(animationPath: 'assets/animations/addtocart.json'),
    );
  }
}
