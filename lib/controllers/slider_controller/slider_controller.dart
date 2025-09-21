// controllers/slider_controller.dart
import 'package:Xkart/models/slider_mode/slider_model.dart';
import 'package:Xkart/services/api_services.dart';
import 'package:get/get.dart';

class SliderController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  
  // Replace with your actual API base URL
  static const String _baseUrl = 'YOUR_BASE_URL_HERE';
  static const String slidersEndpoint = 'https://moment-wrap-backend.vercel.app/api/customer/sliders';

  // Observables
  final RxList<SliderModel> sliders = <SliderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
  }

  /// Fetch sliders from API
  Future<void> fetchSliders({int? limit}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      Map<String, dynamic>? queryParameters;
      if (limit != null) {
        queryParameters = {'limit': limit};
      }

      final response = await _apiServices.getRequest(
        url: '$slidersEndpoint',
        queryParameters: queryParameters,
        authToken: false,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true) {
          final List<dynamic> slidersData = responseData['sliders'] ?? [];
          sliders.assignAll(
            slidersData.map((slider) => SliderModel.fromJson(slider)).toList()
          );
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load offers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh sliders
  Future<void> refreshSliders() async {
    await fetchSliders();
    if (!hasError.value && sliders.isNotEmpty) {
      Get.snackbar(
        'Success',
        'Offers refreshed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Retry loading
  void retry() => fetchSliders();

  /// Get sliders with offers only
  List<SliderModel> get offeredSliders => 
      sliders.where((slider) => slider.hasOffer).toList();
}