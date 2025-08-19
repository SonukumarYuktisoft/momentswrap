import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momentswrap/routes/app_pages.dart';
import 'package:momentswrap/routes/app_routes.dart';
import 'package:momentswrap/test.dart';
import 'package:momentswrap/util/common/success_screen.dart';
import 'package:momentswrap/util/not_found_screen/not_fonud_screen.dart';
import 'package:momentswrap/util/themes/app_theme.dart';
import 'package:momentswrap/view/home_screen/home_screen.dart';
import 'package:momentswrap/view/home_screen/product_detail_screen.dart';
import 'package:momentswrap/view/home_screen/search_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      title: 'Flutter Demo',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,

      // GetX Navigation

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: AppRoutes.notFound,
        page: () => NotFoundScreen(),
      ),



      home: Test(),


    );
  }
}
