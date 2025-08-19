import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressPickerHelper {
  /// Get current position (latitude, longitude)
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Step 1: Check if location service enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Step 2: Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Step 3: Get current location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Convert lat-long to readable address
  static Future<String?> getAddressFromLatLng(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      return null;
    } catch (e) {
      throw Exception("Error in fetching address: $e");
    }
  }

  /// Directly get user’s current address
  static Future<String?> pickAddress() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) return null;

      return await getAddressFromLatLng(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw Exception("Error in pickAddress: $e");
    }
  }
}
