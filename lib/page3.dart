

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'dart:async';

import 'firebase_options.dart';
// Note: Firebase must be initialized in your main function for this to work.
// e.g., 'await Firebase.initializeApp();'

void main() async {

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BMydemo());
}

class BMydemo extends StatelessWidget {
  const BMydemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> {
  File? _selfieFile;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobNumController = TextEditingController();

  // Function to handle location permissions and fetching
  Future<void> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      }
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));
      }
      return;
    }
  }

  Future<void> captureSelfie() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 90);
    if (image != null) {
      setState(() {
        _selfieFile = File(image.path);
      });
    }
  }

  Future<void> getCurrentLocation() async {
    await _handleLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _mobNumController.text =
      'Lat: ${_currentPosition?.latitude.toStringAsFixed(4)}, Lon: ${_currentPosition?.longitude.toStringAsFixed(4)}';
    });
  }

  Future<String?> uploadSelfieToStorage(File file, String userId) async {
    try {
      String fileName = path.basename(file.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_selfies/$userId/$fileName');

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> storeUserData(String name, String mobileNumber, String selfieUrl,
      Position position) async {
    // This example assumes the user is already authenticated
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('traveldata');

      await users.doc(userId).set({
        'name': name,
        'mobileNumber': mobileNumber,
        'selfieUrl': selfieUrl,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'createdAt': FieldValue.serverTimestamp(),
      }).then((value) {
        print("User Data Added");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully!')));
      }).catchError((error) {
        print("Failed to add user data: $error");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save data: $error')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not authenticated. Cannot save data.')));
    }
  }

  // Unified save function
  Future<void> saveProfileData() async {
    if (_selfieFile != null && _currentPosition != null && _nameController.text.isNotEmpty) {
      // Use a generic placeholder userId if not authenticated for testing purposes,
      // or ensure user is authenticated before calling this function.
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'test_user_id';

      String? selfieUrl = await uploadSelfieToStorage(_selfieFile!, userId);

      if (selfieUrl != null) {
        await storeUserData(
          _nameController.text,
          // Use the phone number from Firebase Auth if available, otherwise the text field value (which currently holds location info)
          FirebaseAuth.instance.currentUser?.phoneNumber ?? 'N/A',
          selfieUrl,
          _currentPosition!,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload selfie.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please capture a selfie, get your location, and enter your name.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Display captured selfie if available
            if (_selfieFile != null)
              Image.file(_selfieFile!, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: captureSelfie,
              child: const Text('Capture Selfie'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mobNumController,
              readOnly: true, // Display location here
              decoration: const InputDecoration(
                hintText: "Current Location (Lat/Lon)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getCurrentLocation,
              child: const Text('Get Current Location'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveProfileData, // Call the unified save function
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Save Profile Data',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobNumController.dispose();
    super.dispose();
  }
}
