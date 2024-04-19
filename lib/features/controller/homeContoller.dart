
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController{

//    Future<void> getCurrentLocation() async {
//   try {
//     var permissionStatus = await Permission.location.request();
//     if (permissionStatus.isGranted) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           position.latitude, position.longitude);
//       if (placemarks != null && placemarks.isNotEmpty) {
//         setState(() {
//           currentLocation = placemarks[0].locality ?? 'Unknown';
//           print(currentLocation);
//         });
//       } else {
//         setState(() {
//           currentLocation = 'No placemark found';
//         });
//       }
//     } else {
//       setState(() {
//         currentLocation = 'Permission denied by user';
//       });
//     }
//   } catch (e) {
//     print("Error getting location: $e");
//     setState(() {
//       currentLocation = 'Error: $e';
//     });
//   }
// }

}