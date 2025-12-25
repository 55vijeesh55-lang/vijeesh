



// Note: The google_maps package often refers to web, for mobile URL launching we use url_launcher
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vijeesh/user_model.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart'; // Needed if you want to show a SnackBar/Dialog

import 'dart:io' show Platform; // Used for platform checks if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: MyFirestoreDataDisplay(),
      color: Colors.blue,
    );
  }
}

class MyFirestoreDataDisplay extends StatefulWidget {
  const MyFirestoreDataDisplay({super.key});

  @override
  _MyFirestoreDataDisplayState createState() => _MyFirestoreDataDisplayState();
}

class _MyFirestoreDataDisplayState extends State<MyFirestoreDataDisplay> {
  List<UserModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('traveldata')
          .get();

      setState(() {
        _dataList = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return UserModel.fromMap(data);
        }).toList();
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Implementation for making a phone call
  _makePhoneCall(String? phoneNumber) async {

    final Uri launchUri = Uri(
      scheme: 'tel',path: phoneNumber ?? '',
    );
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        print("Could not launch phone call URI: $launchUri");
      }
    } else {
      print("Invalid phone number");
    }
  }


// ... within your class/widget state ...

  Future<void> _launchMap(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      // Correct URL format for Google Maps directions/location
      // Use 'q=$latitude,$longitude' to search for the specific coordinates.
      final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      final Uri uri = Uri.parse(googleMapsUrl);

      // It's recommended to wrap the launch attempt in a try-catch block for robust error handling.
      try {
        if (await canLaunchUrl(uri)) {
          // Use externalApplication mode for web or native map app preference
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Fallback if the URL scheme isn't totally supported
          print('Could not find a suitable application to launch $googleMapsUrl');
          // You could display a user-friendly message here (e.g., using a SnackBar)
        }
      } catch (e) {
        // Handle any errors that occur during the launch process
        print('An error occurred while launching $googleMapsUrl: $e');
        throw 'Could not launch map: $e';
      }
    } else {
      // Handle the case where coordinates are null
      print('Latitude or longitude is null. Cannot launch map.');
      // Display an alert to the user that location data is missing
    }
  }

// Note: The previous _launchGoogleUrl function you wrote works for just opening the main page of Google,
// but the _launchMap function above specifically addresses opening a map view using coordinates.

 /* Future<void> _launchGoogleUrl(double? latitude, double? longitude) async {
    final Uri googleUrl = Uri.parse('https://www.google.com');

    // Use canLaunchUrl to check if the URL scheme is supported
    if (await canLaunchUrl(googleUrl)) {
      // Specify the mode for web compatibility
      await launchUrl(
        googleUrl,
        // For web, use external application/tab
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Handle the error (e.g., show a dialog or log the error)
      print('Could not launch URL: $googleUrl');
      throw 'Could not launch $googleUrl';
    }
  }


  // Implementation for launching a map using url_launcher
  _launchMap(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      // Standard Google Maps URL scheme
      final uri = Uri.parse('www.google.com');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch map for $uri');
        // Optionally show a SnackBar or AlertDialog
      }
    } else {
      print("Invalid coordinates");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Data')),
      body: _dataList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          UserModel user = _dataList[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            color: Colors.greenAccent,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    maxRadius: 50.0,
                    minRadius: 20.0,
                    // Add backgroundImage logic here if applicable
                  ),
                  title: Text(user.name ?? 'No Name'),
                  subtitle: Text(' ${user.status?.toString() ?? "ONLINE"}'),
                ),
                ButtonBar(
                  children: <Widget>[
                    ElevatedButton(
                      // Pass the actual user data to the function call
                      onPressed: () => _makePhoneCall(user.mobilenumber),
                      child: const Text('Call Now'),
                    ),
                    ElevatedButton(
                      // Pass the actual user data to the function call
                      //onPressed: () => _launchMap(user.latitude, user.longitude),
                      onPressed: () => _launchMap( user.latitude, user.longitude),
                      child: const Text('Open Google Map'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MyFirestoreDataDisplay(),
      color: Colors.blue,
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyFirestoreDataDisplay extends StatefulWidget {
  const MyFirestoreDataDisplay({super.key});

  @override
  _MyFirestoreDataDisplayState createState() => _MyFirestoreDataDisplayState();
}

class _MyFirestoreDataDisplayState extends State<MyFirestoreDataDisplay> {
  // A list to store your document data

  List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('traveldata') // Replace with your collection name
          .get();

      setState(() {
        _dataList = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      print("Error fetching data: $e");
      // Handle error, e.g., show a snackbar or an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Data')),
      body: _dataList.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = _dataList[index];
                // Display your data in a ListTile or custom widget

                */
/* return Card(margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
           child:ListTile( title: Text(data['name'] ?? 'No Name'), // Example field
            subtitle: Text(data['description'] ?? 'No Description'),) // Example field
            // Add more widgets to display other fields
          );

          *//*

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  color: Colors.greenAccent, // Spacing around the card
                  elevation: 4.0, // Shadow depth for the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Rounded corners for the card
                  ),
                  child: Column(
                    // Use a Column to arrange widgets vertically within the card
                    mainAxisSize: MainAxisSize
                        .min, // Make the column take minimum vertical space
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          maxRadius: 50.0,
                          minRadius: 20.0,
                        ), // Display data in a ListTile
                        title: Text(
                          data['name'] ?? 'No Name',
                        ), // Display 'name' from data, or 'No Name' if null
                        subtitle: Text(
                          data['description'] ?? 'No Description',
                        ), // Display 'description' or 'No Description'
                      ),
                      ButtonBar(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('call'),
                            onPressed: () {
                              */
/* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const BMydemo()));*//*

                            },
                          ),
                          ElevatedButton(
                            child: const Text('Map'),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      // Add more widgets here to display other fields from the 'data' map
                    ],
                  ),
                );
              },
            ),
    );
  }
}
*/
