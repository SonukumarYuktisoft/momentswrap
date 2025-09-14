import 'package:flutter/material.dart';
import 'package:Xkart/util/constants/simmers/banner_shimmer.dart';
import 'package:Xkart/util/constants/simmers/category_shimmer.dart';
import 'package:Xkart/util/constants/simmers/horizontal_productList_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 16),
        BannerShimmer(),
        SizedBox(height: 16),
        CategoryShimmer(),
        SizedBox(height: 16),
        HorizontalProductListShimmer(),
        SizedBox(height: 16),
        HorizontalProductListShimmer(),
      ],
    );
  }
}
