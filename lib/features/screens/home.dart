import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherpmna/core/common.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherpmna/features/screens/historypage.dart';
import '../../core/widgets/customsearch.dart';
import '../../main.dart';

var currentLocation = '';

class Home extends StatefulWidget {
  final String currentLocation1;
  Home({
    super.key, required this.currentLocation1,
  });

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  Future<Map<String, dynamic>>? _weatherData;
     late  String currentLocation = widget.currentLocation1;

  ///api
  Future<Map<String, dynamic>> _fetchWeatherData(String location) async {
    final apiKey = '55b07ab9a8a059147d857d682b9f5abb';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Location not found');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  ///Get current location
  // Future<void> getCurrentLocation() async {
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
  //         _updateWeatherData();
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

  Future<void> fetchWeatherData1(String location) async {
    try {
      final Map<String, dynamic> weatherData =
          await _fetchWeatherData(location);
      setState(() {
        _weatherData = Future.value(weatherData);
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  void initState() {
    _weatherData = _fetchWeatherData(currentLocation);
    print('currentLocation');
    _updateWeatherData();
    super.initState();
  }

  Future<void> _updateWeatherData() async {
    setState(() {
      _weatherData = _fetchWeatherData(currentLocation.toString());
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? Pallete.darkModeTheme : Pallete.lightModeTheme,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Icon(
              Icons.menu_sharp,
              size: width * 0.07,
            ),
          ),
          titleSpacing: width * 0.17,
          title: Text(
            'WeatherApp',
            style: GoogleFonts.poppins(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.1),
              child: GestureDetector(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                        onLocationSelected: (String location) {
                          setState(() {
                            currentLocation =
                                location; // Update current location in Home widget
                          });
                          fetchWeatherData1(
                              location); // Fetch weather data for the selected location
                        },
                      ),
                    );
                  },
                  child: Icon(Icons.search, size: width * 0.07)),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              SizedBox(height: height * .05),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(width: width * .06),
                    Icon(Icons.history, color: Colors.white),
                    SizedBox(width: width * .06),
                    Text(
                      'History',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const History()));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(width: width * .06),
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: Image(image: AssetImage('assets/img_2.png'))),
                    SizedBox(width: width * .06),
                    Text('Dark Mode', style: TextStyle(color: Colors.white)),
                    SizedBox(width: width * .15),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                          // Update the theme based on the new mode
                          if (isDarkMode) {
                            isDarkMode = true;
                            // Set dark theme
                            // You can customize your dark theme as needed
                            // For simplicity, let's use ThemeData.dark()
                            // You might want to use ThemeData.from to copy the existing theme and modify only the necessary properties
                            // or define a custom dark theme
                          } else {
                            isDarkMode = false;
                            // Set light theme
                            // Similarly, you can customize your light theme
                          }
                        });
                      },
                    )
                  ],
                ),
                onTap: () {
                  // Handle onTap if needed
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: _weatherData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('_weatherData');
                print(_weatherData);
                print('_weatherData');
                print('Error:');
                print('Error: ${snapshot.error}');
                print('Error:');
                return Padding(
                  padding: EdgeInsets.only(left: width * .35, top: height * .4),
                  child: const Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Please wait, Fecthing'),
                    ],
                  ),
                );

                /// Display a loading indicator while data is being fetched
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Padding(
                  padding: EdgeInsets.only(left: width * .2, top: height * .4),
                  child: const Text('Location not found please search'),
                );
              } else {
                final weatherData = snapshot.data;
                if (weatherData == null) {
                  return Padding(
                    padding:
                        EdgeInsets.only(left: width * .35, top: height * .4),
                    child: const Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('Please wait, Fecthing'),
                      ],
                    ),
                  );
                } else {
                  /// Data fetched successfully, update UI with weather information
                  final weatherData = snapshot.data!;
                  final temperature = weatherData['main']['temp'];
                  final climate = weatherData['weather'][0]['description'];
                  final windSpeed = weatherData['wind']['speed'];
                  final rainChance = weatherData.containsKey('rain')
                      ? weatherData['rain']['1h']
                      : 0.0;

                  return Column(
                    children: [
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * .03),
                            child: currentLocation.isEmpty
                                ? Text('IN | RAMAPURAM',
                                    style: TextStyle(
                                        fontSize: width * .04,
                                        fontWeight: FontWeight.w200))
                                : Text('IN | ${currentLocation}',
                                    style: TextStyle(
                                        fontSize: width * .04,
                                        fontWeight: FontWeight.w200)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * .03),
                            child: Text('$climate',
                                style: GoogleFonts.ptSans(
                                  fontSize: width * .03,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * .2),
                            child: Text('$temperature°',
                                style: GoogleFonts.abel(
                                    fontSize: width * .15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.cloud,
                            size: width * .2,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: width * .025),
                            child: Container(
                              width: width * .95,
                              height: height * .2,
                              decoration: BoxDecoration(
                                  color: isDarkMode == false
                                      ? Color.fromRGBO(176, 188, 200, 1.0)
                                      : Color.fromRGBO(35, 40, 43, 1.0),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(
                                            pi), // Rotate 180 degrees
                                        child: Icon(CupertinoIcons.thermometer,
                                            size: width * .08),
                                      ),
                                      SizedBox(height: height * .02),
                                      Text(
                                        '$temperature°C',
                                        style: TextStyle(fontSize: width * .03),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: height * .1,
                                          width: width * .18,
                                          child: Image(
                                            color: isDarkMode == false
                                                ? Color.fromRGBO(
                                                    36, 91, 130, 1.0)
                                                : Colors.white,
                                            image: AssetImage(
                                              'assets/img.png',
                                            ),
                                          )),
                                      Text(
                                        '${rainChance}%',
                                        style: TextStyle(fontSize: width * .08),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: height * .05,
                                          width: width * .1,
                                          child: Image(
                                            image:
                                                AssetImage('assets/img_1.png'),
                                          )),
                                      SizedBox(height: height * .005),
                                      Text(
                                        '${windSpeed} Km / h',
                                        style: TextStyle(fontSize: width * .03),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        'Today',
                        style: TextStyle(
                            fontSize: width * .04, color: appBarColor),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: width * .04,
                            ),
                            Container(
                              width: width * .35,
                              height: height * .22,
                              decoration: BoxDecoration(
                                  color: isDarkMode == false
                                      ? Color.fromRGBO(176, 188, 200, 1.0)
                                      : Color.fromRGBO(30, 31, 33, 1.0),
                                  borderRadius: BorderRadius.circular(35)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('09:00 AM',
                                          style:
                                              TextStyle(fontSize: width * .05)),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text('$temperature°',
                                              style: TextStyle(
                                                  fontSize: width * .06)),
                                          SizedBox(width: width * .02),
                                          Icon(
                                            Icons.cloud,
                                            size: width * .06,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * .01),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: height * .04,
                                                  width: width * .05,
                                                  child: Image(
                                                      color: isDarkMode == false
                                                          ? Color.fromRGBO(
                                                              36, 91, 130, 1.0)
                                                          : Colors.white,
                                                      image: AssetImage(
                                                          'assets/img.png'))),
                                              Text('${rainChance}%',
                                                  style: TextStyle(
                                                      fontSize: width * .02)),
                                            ],
                                          ),
                                          SizedBox(width: width * .1),
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: height * .04,
                                                  width: width * .05,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          'assets/img_1.png'))),
                                              Text('${windSpeed}Km /h',
                                                  style: TextStyle(
                                                      fontSize: width * .02)),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * .002),
                                      Text(climate,
                                          style:
                                              TextStyle(fontSize: width * .03))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * .04,
                            ),
                            Container(
                              width: width * .35,
                              height: height * .22,
                              decoration: BoxDecoration(
                                  color: isDarkMode == false
                                      ? Color.fromRGBO(176, 188, 200, 1.0)
                                      : Color.fromRGBO(30, 31, 33, 1.0),
                                  borderRadius: BorderRadius.circular(35)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('12:00 PM',
                                          style:
                                              TextStyle(fontSize: width * .05)),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text('$temperature°',
                                              style: TextStyle(
                                                  fontSize: width * .06)),
                                          SizedBox(width: width * .02),
                                          Icon(
                                            Icons.cloud,
                                            size: width * .06,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * .01),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: height * .04,
                                                  width: width * .05,
                                                  child: Image(
                                                      color: isDarkMode == false
                                                          ? Color.fromRGBO(
                                                              36, 91, 130, 1.0)
                                                          : Colors.white,
                                                      image: AssetImage(
                                                          'assets/img.png'))),
                                              Text('${rainChance}%',
                                                  style: TextStyle(
                                                      fontSize: width * .02)),
                                            ],
                                          ),
                                          SizedBox(width: width * .1),
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: height * .04,
                                                  width: width * .05,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          'assets/img_1.png'))),
                                              Text('${windSpeed}Km /h',
                                                  style: TextStyle(
                                                      fontSize: width * .02)),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * .002),
                                      Text(climate,
                                          style:
                                              TextStyle(fontSize: width * .03))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * .04,
                            ),
                            Container(
                              width: width * .35,
                              height: height * .22,
                              decoration: BoxDecoration(
                                  color: isDarkMode == false
                                      ? Color.fromRGBO(176, 188, 200, 1.0)
                                      : Color.fromRGBO(30, 31, 33, 1.0),
                                  borderRadius: BorderRadius.circular(35)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('03:00 PM',
                                          style:
                                              TextStyle(fontSize: width * .05)),
                                      SizedBox(height: height * .005),
                                      Row(
                                        children: [
                                          Text('$temperature°',
                                              style: TextStyle(
                                                  fontSize: width * .06)),
                                          SizedBox(width: width * .02),
                                          Icon(
                                            Icons.cloud,
                                            size: width * .06,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * .01),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: height * .04,
                                                  width: width * .05,
                                                  child: Image(
                                                      color: isDarkMode == false
                                                          ? Color.fromRGBO(
                                                              36, 91, 130, 1.0)
                                                          : Colors.white,
                                                      image: AssetImage(
                                                          'assets/img.png'))),
                                              Text('${rainChance}%',
                                                  style: TextStyle(
                                                      fontSize: width * .02)),
                                            ],
                                          ),
                                          SizedBox(width: width * .1),
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height: height * .04,
                                                  width: width * .05,
                                                  child: const Image(
                                                      image: AssetImage(
                                                          'assets/img_1.png'))),
                                              Text('${windSpeed}Km /h',
                                                  style: TextStyle(
                                                      fontSize: width * .02)),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: height * .002),
                                      Text(climate,
                                          style:
                                              TextStyle(fontSize: width * .03))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * .04,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        '5 days forecast',
                        style: TextStyle(
                            fontSize: width * .04, color: appBarColor),
                      ),
                      SizedBox(
                        height: height * .05,
                      ),
                      Container(
                        width: width * .95,
                        height: height * .082,
                        decoration: BoxDecoration(
                            color: isDarkMode == false
                                ? Color.fromRGBO(176, 188, 200, 1.0)
                                : Color.fromRGBO(30, 31, 33, 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: width * .06),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(formattedDay,
                                      style: TextStyle(fontSize: width * .03)),
                                  Text(formattedTime,
                                      style: TextStyle(fontSize: width * .04)),
                                ],
                              ),
                            ),
                            SizedBox(width: width * .06),
                            SizedBox(
                                height: height * .03,
                                width: width * .2,
                                child: Image(
                                  color: isDarkMode == false
                                      ? const Color.fromRGBO(36, 91, 130, 1.0)
                                      : Colors.white,
                                  image: const AssetImage('assets/img_3.png'),
                                )),
                            SizedBox(width: width * .1),
                            Text('26°',
                                style: TextStyle(fontSize: width * .07)),
                            SizedBox(width: width * .15),
                            Text('26°', style: TextStyle(fontSize: width * .04))
                          ],
                        ),
                      )
                    ],
                  );
                }
              }
            }),
      ),
    ));
  }
}
