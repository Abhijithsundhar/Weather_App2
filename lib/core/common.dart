
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

///device height and weight
double height = 0.0;
double width = 0.0;

///App bar color
 var appBarColor = const Color(0xFFFFCA2D);

 ///bgcolor
var bgColor = const Color(0xFF2A2E2E);

/// for changing mode dark and white
class Pallete{
 static var lightModeTheme = ThemeData.light().copyWith(
  drawerTheme: DrawerThemeData(
   backgroundColor: Color.fromRGBO(176, 188, 200, 1.0),
  ),
  scaffoldBackgroundColor: Colors.lightBlue[50],
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.lightBlue[50],
      surfaceTintColor: bgColor,
      iconTheme:  IconThemeData(color: appBarColor),
      titleTextStyle: GoogleFonts.poppins(color: appBarColor)),
  textTheme: TextTheme(

   titleSmall: TextStyle(color: Color.fromRGBO(36, 91, 130, 1.0)),
   titleLarge: TextStyle(color: Color.fromRGBO(36, 91, 130, 1.0)),
   titleMedium: TextStyle(color: Color.fromRGBO(36, 91, 130, 1.0)),
   bodyLarge: TextStyle(color: Color.fromRGBO(36, 91, 130, 1.0)),
   bodyMedium: TextStyle(color: Color.fromRGBO(36, 91, 130, 1.0)),
   bodySmall: TextStyle(color: Color.fromRGBO(36, 91, 130, 1.0)),
  ),
  // hoverColor: const Color.fromRGBO(31, 34, 42, 1),
  listTileTheme: ListTileThemeData(
   titleTextStyle: GoogleFonts.urbanist(color: Colors.black38),
  ),

  elevatedButtonTheme: const ElevatedButtonThemeData(
  ),
  iconTheme: const IconThemeData(color: Color.fromRGBO(36, 91, 130, 1.0)),

 );

 static var darkModeTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor:bgColor,
  appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      iconTheme:  IconThemeData(color:appBarColor),
      titleTextStyle: GoogleFonts.poppins(color: appBarColor)),
  textTheme: TextTheme(
   titleSmall: TextStyle(color: Colors.white),
   titleLarge: const TextStyle(color: Colors.white),
   titleMedium: const TextStyle(color: Colors.white),
   bodyLarge: const TextStyle(color: Colors.white),
   bodyMedium:const TextStyle(color: Colors.white),
   bodySmall:const TextStyle(color: Colors.white),
  ),
  // hoverColor: const Color.fromRGBO(31, 34, 42, 1),
  listTileTheme: ListTileThemeData(
   titleTextStyle: GoogleFonts.urbanist(color: Colors.black38),
  ),
  iconTheme: const IconThemeData(color:Colors.white),
  drawerTheme: DrawerThemeData(
   backgroundColor: bgColor,
  ),
 );

}

/// current date and day
String formattedTime = DateFormat.jm().format(DateTime.now());
String formattedDay = DateFormat.E().format(DateTime.now()).substring(0, 3);