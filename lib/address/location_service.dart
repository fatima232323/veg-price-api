import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<String?> getCurrentAddress() async {
    bool hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      return [
        place.name,
        place.subThoroughfare,
        place.subLocality,
        place.locality,
        place.postalCode,
        place.country
      ]
          .where((element) => element != null && element.trim().isNotEmpty)
          .join(', ');
    } catch (e) {
      print("Location error: $e");
      return null;
    }
  }

  static Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return false;
    }

    return true;
  }
}
