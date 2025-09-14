import 'package:flutter/material.dart';
import 'package:Xkart/util/constants/simmers/widgets/product_card_shimmer.dart';

class HorizontalProductListShimmer extends StatelessWidget {
  const HorizontalProductListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // 👈 fix height for horizontal list
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160, // 👈 fix width for each shimmer card
            child: ProductCardShimmer(),
          );
        },
      ),
    );
  }
}
