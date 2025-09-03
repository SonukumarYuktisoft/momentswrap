import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  // Reactive fields
  RxString location = "".obs;
  RxString city = "".obs;
  RxString state = "".obs;
  RxString country = "".obs;
  RxString pincode = "".obs;
  RxString address = "".obs;

  RxBool isAddressSelected = false.obs;
  RxBool isLoading = false.obs;

  /// Get current location & fetch address
  Future<void> getAddress() async {
    try {
      isLoading.value = true;

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log("❌ Location permission denied again.");
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log("❌ Location permission denied forever. Open settings to enable.");
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
        isLoading.value = false;
        return;
      }

      // Permissions granted → Get current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      log("✅ Position: $currentPosition");

      // Call getAddressFromLatLng
      await getAddressFromLatLng(currentPosition);

    } catch (e) {
      log("⚠️ Error getting location: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Convert LatLng → Address
  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        city.value = place.locality ?? "";
        state.value = place.administrativeArea ?? "";
        country.value = place.country ?? "";
        pincode.value = place.postalCode ?? "";

        address.value =
            " ${place.locality ?? ""}, ${state.value}, ${pincode.value}, ${country.value}, ${place.street}, ${place.locality ?? ""}, ${place.subLocality ?? ""}, ${place.subAdministrativeArea ?? ""}, ${place.thoroughfare ?? ""}, ${place.subThoroughfare ?? ""}";

        location.value = "${place.street ?? ""}, ${place.locality ?? ""}";
        isAddressSelected.value = true;

        log("📍 Address: ${address.value}");
      } else {
        log("⚠️ No placemark found");
      }
    } catch (e) {
      log("⚠️ Error fetching address: $e");
    }
  }
}
