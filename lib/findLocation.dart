import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class FindLocation{

  Future<bool> checkPermission() async {
      final PermissionStatus status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        print("GPS permision granted");
        return true;
      } else if (status.isDenied) {
        await Permission.locationWhenInUse.request();
        print("GPS Access denied");
        
      }
      return false;
    }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    return position;
  }


}