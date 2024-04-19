import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherpmna/features/screens/home.dart';
import 'package:weatherpmna/main.dart';
import '../../core/common.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> searchHistory = [];

  @override
  void initState() {
    loadSearchHistory();
    super.initState();
  }

  Future<void> loadSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searches') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode == false ? Colors.lightBlue[50] : bgColor,
      appBar: AppBar(
        backgroundColor:
        isDarkMode == false ? Color.fromRGBO(176, 188, 200, 1.0) : bgColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home(currentLocation1: currentLocation,)));
          },
          child: Icon(
            Icons.arrow_back,
            color: appBarColor,
            size: width * 0.07,
          ),
        ),
        titleSpacing: width * 0.17,
        title: Text(
          'History',
          style: GoogleFonts.poppins(
            color: appBarColor,
            fontSize: width * 0.05,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: searchHistory.map((search) {
            List<String> details = search.split(' - ');
            String locationName = details[0];
            String dateTimeString = details[1];

            /// DateFormat to parse the date and time to string
            DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
            DateTime dateTime = format.parse(dateTimeString);

            /// Formatting the date and time separately
            String formattedDayOfWeek = DateFormat.E().format(dateTime);
            String formattedTime = DateFormat("hh:mm a").format(dateTime);
            return Padding(
              padding: EdgeInsets.only(
                  left: width * .05, top: height * .02, right: width * .02),
              child: Container(
                decoration: BoxDecoration(
                    color: isDarkMode == false
                        ? Color.fromRGBO(176, 188, 200, 1.0)
                        : Color.fromRGBO(30, 31, 33, 1),
                    borderRadius: BorderRadius.circular(10)),
                height: height * .06,
                width: width * .9,
                child: Row(
                  children: [
                    SizedBox(width: width * .05),
                    Row(
                      children: [
                        Text(formattedDayOfWeek,
                            style: TextStyle(
                                color: isDarkMode == false
                                    ? Color.fromRGBO(36, 91, 130, 1.0)
                                    : Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: width * .03)),
                      ],
                    ),
                    SizedBox(width: width * .09),
                    SizedBox(
                      width: width * .4,
                      child: Text(locationName,
                          style: TextStyle(
                              color: isDarkMode == false
                                  ? Color.fromRGBO(36, 91, 130, 1.0)
                                  : Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: width * .03)),
                    ),
                    SizedBox(width: width * .1),
                    Text(formattedTime,
                        style: TextStyle(
                            color: isDarkMode == false
                                ? Color.fromRGBO(36, 91, 130, 1.0)
                                : Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: width * .03)),
                    SizedBox(width: width * .05),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
