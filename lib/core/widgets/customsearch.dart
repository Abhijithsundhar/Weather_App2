import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherpmna/main.dart';

typedef LocationCallback = void Function(String location);

class CustomSearchDelegate extends SearchDelegate<String> {
  final LocationCallback onLocationSelected;

  CustomSearchDelegate({required this.onLocationSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar
    return [
      IconButton(
        icon: Icon(Icons.clear,
            color: isDarkMode == false ? Color.fromRGBO(36, 91, 130, 1.0) : Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar
    return IconButton(
      icon: Icon(Icons.arrow_back, color: isDarkMode == false ? Color.fromRGBO(36, 91, 130, 1.0) : Colors.white),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Results based on the search query
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions that appear when the user types in the search bar
    return FutureBuilder<List<Location>>(
      future: searchLocations(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('No location found'));
        } else {
          final locations = snapshot.data!;
          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return ListTile(
                title: Text(location.name, style: TextStyle(color: isDarkMode == false ? Color.fromRGBO(36, 91, 130, 1.0) : Colors.white)),
                onTap: () async {
                  await storeSearchedPlace(location.name); // Store the searched place
                  close(context, location.name); // Return the selected location
                  onLocationSelected(location.name);
                },
              );
            },
          );
        }
      },
    );
  }

  // Function to search for locations using the geocoding package
  Future<List<Location>> searchLocations(String query) async {
    final apiKey = '55b07ab9a8a059147d857d682b9f5abb'; // Replace with your API key
    final url =
        'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((location) => Location.fromJson(location)).toList();
    } else {
      throw Exception('Failed to search for locations: ${response.statusCode}');
    }
  }

  // Function to store searched place using SharedPreferences
  Future<void> storeSearchedPlace(String locationName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> searches = prefs.getStringList('searches') ?? [];
    final DateTime now = DateTime.now();
    final String formattedDateTime = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';
    searches.add('$locationName - $formattedDateTime');
    await prefs.setStringList('searches', searches);
  }
}

class Location {
  final String name;

  Location({required this.name});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
    );
  }
}
