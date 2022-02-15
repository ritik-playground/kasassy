import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kasassy/data/providers/_base_provider.dart';

class DeviceProvider extends BaseDeviceProvider {
  @override
  Future<String> getUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
          'Location permissions are permanently denied.',
        );
      }

      final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemark = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      ).then((value) => value[0]);
      final formattedAddress = '${placemark.locality}, ${placemark.country}';
      return formattedAddress;
    } catch (e) {
      print(e);
      throw GetUserLocationFailure();
    }
  }

  @override
  void dispose() {}
}

class GetUserLocationFailure implements Exception {}
