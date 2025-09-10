import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 200, // 👈 fix height
        width: 160, // 👈 fix width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 100, width: double.infinity, color: Colors.grey),
            SizedBox(height: 8),
            Container(height: 16, width: 100, color: Colors.grey),
            SizedBox(height: 8),
            Container(height: 14, width: 60, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

//   Widget _buildShimmerCard() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 👇 Product Image placeholder
//             Container(
//               width: 80,
//               height: 80,
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(width: 12),
//             // 👇 Text placeholders
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(height: 16, width: 120, color: Colors.grey.shade400),
//                   SizedBox(height: 8),
//                   Container(height: 14, width: 180, color: Colors.grey.shade400),
//                   SizedBox(height: 8),
//                   Container(height: 14, width: 100, color: Colors.grey.shade400),
//                   SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Container(height: 14, width: 40, color: Colors.grey.shade400),
//                       SizedBox(width: 8),
//                       Container(height: 14, width: 60, color: Colors.grey.shade400),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
