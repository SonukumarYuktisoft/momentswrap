import 'package:Xkart/controllers/review_controller/review_controller.dart';
import 'package:Xkart/view/reviews_screen/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = ReviewController();
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text('Test Page'),
          ),
          ElevatedButton(
            onPressed: () {
              reviewController.getProductReviews('68c7c43e38c266609a2d45e6');
            },
            child: Text('Fetch Reviews'),
          ),
          Obx(
             () {
              if (reviewController.isLoading.value) {
                return CircularProgressIndicator();
              } else if (reviewController.hasError.value) {
                return Text('Error: ${reviewController.errorMessage.value}');
              } else {
                final reviews = reviewController.productReviews;
                print(reviews);
                return Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ReviewCard(review:   review);
                    },
                  ),
                );
              }
            
            }
          )
        ],
      ),
    );
  }
}