import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/common.dart';
import 'features/screens/splash.dart';

Future<void> main() async {
  // Initialize locale data
  await initializeDateFormatting();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

bool isDarkMode = false;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? Pallete.darkModeTheme : Pallete.lightModeTheme,
      home:  IntroScreen(),
    );
  }
}
