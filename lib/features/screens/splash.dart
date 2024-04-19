import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home.dart';


class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  var currentLocation = '';

  Future<void> getCurrentLocation() async {
    try {
      var permissionStatus = await Permission.location.request();
      if (permissionStatus.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          setState(() {
            currentLocation = placemarks[0].locality ?? 'Unknown';
            print(currentLocation);
          });
        } else {
          setState(() {
            currentLocation = 'No placemark found';
          });
        }
      } else {
        setState(() {
          currentLocation = 'Permission denied by user';
        });
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        currentLocation = 'Error: $e';
      });
    }
  }
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(),
            Image.asset("assets/weather.png"),
            const Spacer(flex: 4),
            const Text.rich(
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(text: "Find "),
                  TextSpan(
                    text: "Weather ",
                    style: TextStyle(
                      color: Color.fromRGBO(36, 91, 130, 1.0),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            const Text(
              "Stay ahead of the weather with our app, delivering accurate forecasts and real-time updates wherever you go",
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Home(currentLocation1: currentLocation,),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(176, 188, 200, 1.0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              child: const Text(
                "Get start",
                style: TextStyle(fontSize: 18,),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
