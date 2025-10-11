import 'package:Xkart/view/slider/slider_controller/slider_controller.dart';
import 'package:Xkart/test.dart';
import 'package:Xkart/util/constants/app_colors.dart';
import 'package:Xkart/util/constants/simmers/banner_shimmer.dart';
import 'package:Xkart/view/home_screen/home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    SliderController sliderController = Get.put(SliderController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        if (sliderController.isLoading.value) {
          return const BannerShimmer();
        } else if (sliderController.hasError.value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${sliderController.errorMessage.value}'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: sliderController.fetchSliders,
                child: const Text('Retry'),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Special Offers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 12),
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: sliderController.sliders.map((s) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ModernBannerCard(
                        imageUrl: s.images.isNotEmpty ? s.images[0] : '',
                        title: s.name,
                        subtitle: s.shortDescription,
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }
      }),
    );
  }
}
