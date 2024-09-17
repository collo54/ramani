import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:ramaniride/constants/colors.dart';

class LocationService {
  Location location = Location();

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "LocationService class _checkPermission method Exception: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kred236575710,
          textColor: kwhite25525525510,
          fontSize: 16.0);
    }
    return true;
  }

  Future<LocationData?> getLocation() async {
    try {
      if (await checkPermission()) {
        return await location.getLocation();
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "LocationService class _getLocation method Exception: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kred236575710,
          textColor: kwhite25525525510,
          fontSize: 16.0);
    }
    return null;
  }
}
