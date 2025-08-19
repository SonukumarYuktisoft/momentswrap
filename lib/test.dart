import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:momentswrap/controllers/location_controller/location_controller.dart';
import 'package:momentswrap/util/helpers/share_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  LocationController locationController = Get.put(LocationController());
  final TextEditingController controller = TextEditingController();

  final List<String> fruits = [
    "Apple",
    "Banana",
    "Mango",
    "Orange",
    "Grapes",
    "Watermelon",
    "Pineapple",
    "Strawberry",
    "Blueberry",
    "Cherry",
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TypeAhead Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TypeAheadField<String>(
                // Suggestions ka source
                suggestionsCallback: (pattern) {
                  return fruits
                      .where(
                        (fruit) =>
                            fruit.toLowerCase().startsWith(pattern.toLowerCase()),
                      )
                      .toList();
                },
          
                // TextField ka UI
                builder: (context, textEditingController, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: "Search fruits...",
                      border: OutlineInputBorder(),
                    ),
                  );
                },
          
                // Suggestion list item UI
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(suggestion),
                  );
                },
          
                // Jab suggestion select ho
                onSelected: (suggestion) {
                  controller.text = suggestion;
                  debugPrint("Selected: $suggestion");
                },
          
                // Agar kuch nahi mila
                emptyBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No items found"),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ShareHelper.shareProduct(
                    name: "Wooden Personalized Frame",
                    price: "499",
                    currency: "INR",
                    offer: "50% OFF for limited time!",
                    imageUrl:
                        "https://m.media-amazon.com/images/I/41THqgXO0ML._SX300_SY300_QL70_FMwebp_.jpg",
                    // shareUrl: "https://myecom.com/product/123",
                  );
                },
                child: Text("Share Product"),
              ),
              ElevatedButton(
                onPressed: () => (),
                child: Text('tekeAddress'),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      locationController.getAddress();
                    },
                    child: Text('Address Picker'),
                  ),
                  Text(
                    locationController.city.value,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Text(locationController.address.value),
                  Text(locationController.isAddressSelected.string),
                ],
              ),
          
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 100, // shimmer length
                  height: 60,
                  color: const Color.fromARGB(255, 195, 24, 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ShareHelper {
//   static final Dio _dio = Dio();

//   /// Share Product with fields
//   static Future<void> shareProduct({
//     required String name,
//      String ? price,
//      String ? currency,
//      String? offer,
//     required String imageUrl,
//      String ? shareUrl,
//   }) async {
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final filePath = '${tempDir.path}/product_${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // download image
//       await _dio.download(imageUrl, filePath);

//       // create share message
//       final shareText = """
// 🛍️ $name
// 💰 Price: $currency $price
// 🎁 Offer: $offer
// 🔗 Buy here: $shareUrl
// """;

//       // open share sheet
//       await Share.shareXFiles(
//         [XFile(filePath)],
//         text: shareText,
//         subject: "Check out this product!",
//       );
//     } catch (e) {
//       print("❌ Error while sharing product: $e");
//     }
//   }
// }

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            leading: Container(height: 40, width: 40, color: Colors.white),
            title: Container(
              height: 16,
              width: double.infinity,
              color: Colors.white,
            ),
            subtitle: Container(height: 14, width: 150, color: Colors.white),
          ),
        );
      },
    );
  }
}
