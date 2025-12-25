

// Keep all your imports at the top of the file (as in the previous response)
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'user_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const MaterialApp(
      title: 'User Profile App',
      home: MyHomePage(),
    ),
  );
}
// Keep MyHomePage Stateless Widget declaration the same
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyhomePageState();
}


class MyhomePageState extends State<MyHomePage> {
  // Initialize UserModel with a dummy or initial value
  UserModel _userModel = UserModel(userId: 'temp_user_id');

  Position? _currentPosition;

  // Use default values for auto save
  final TextEditingController _nameController = TextEditingController(text: 'Auto User');
  final TextEditingController _mobNumController = TextEditingController(text: '1234567890');
  final TextEditingController _locationDisplayController = TextEditingController();

  // Add loading state indicators
  bool _isLoading = true;
  String _statusMessage = 'Initializing...';


  // --- AUTO SAVE LOGIC ADDED HERE ---
  @override
  void initState() {
    super.initState();
    // This calls the asynchronous process as soon as the widget initializes
    _initializeAndSaveData();
  }

  void _initializeAndSaveData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Getting location, authenticating, and saving data...';
    });

    // Reuse the existing function that does all the work
    await saveProfileData();

    setState(() {
      _isLoading = false;
      _statusMessage = 'Data operation complete. Check Firestore.';
    });
  }
  // --- END AUTO SAVE LOGIC ---


  @override
  void dispose() {
    _nameController.dispose();
    _mobNumController.dispose();
    _locationDisplayController.dispose();
    super.dispose();
  }

  // --- Location Handling ---
  // (Implement _handleLocationPermission and getCurrentLocation exactly as before)
  Future<void> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) { /* ... */ }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) { /* ... */ }
    if (permission == LocationPermission.deniedForever) { /* ... */ }
  }

  Future<void> getCurrentLocation() async {
    await _handleLocationPermission();
    if (!mounted) return;
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _locationDisplayController.text = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location retrieved successfully!')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  // --- Firebase Firestore (storeUserData function remains the same) ---
  Future<void> storeUserData(String name, String mobileNumber, Position position) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('traveldata');
      _userModel.name = name;
      _userModel.mobilenumber = mobileNumber;
      await users.doc(userId).set({ /* ... data map ... */ });
      // ... (handle then/catchError blocks as before)
    } else { /* ... */ }
  }

  // Unified save function (remains the same as the last corrected version)
  Future<void> saveProfileData() async {
    // Basic validation - location needs time to acquire
    if (_currentPosition == null || _nameController.text.isEmpty || _mobNumController.text.isEmpty) {
      // Note: This Snackbar might not show during initial load if context isn't ready
      return;
    }


    // Ensure user is authenticated (with anonymous login)
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // ... (anonymous login logic as before) ...
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
        currentUser = userCredential.user;
        _userModel = UserModel(userId: currentUser!.uid);
      } catch (e) { /* ... handle error ... */ return; }
    }

    String userId = currentUser.uid;
    String name = _nameController.text;
    String mobileNum = _mobNumController.text;
    Position currentPosition = _currentPosition!;

    await storeUserData(name, mobileNum, currentPosition);
  }


  @override
  Widget build(BuildContext context) {
    // Modify the build method to show loading indicator or form
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile (Auto Save)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(_statusMessage),
            ],
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Use TextFields with pre-filled controllers
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'),),
              const SizedBox(height: 10),
              TextField(controller: _mobNumController, decoration: const InputDecoration(labelText: 'Mobile Number'), keyboardType: TextInputType.phone,),
              const SizedBox(height: 10),
              TextField(controller: _locationDisplayController, decoration: const InputDecoration(labelText: 'Location'), readOnly: true,),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: getCurrentLocation, child: const Text('Refresh Location (Manual)'),),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: saveProfileData, child: const Text('Save Profile Data (Manual)'),),
            ],
          ),
        ),
      ),
    );
  }
}



/*


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'user_model.dart';
import 'firebase_options.dart'; // Ensure this file exists and is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FIX: Wrap MyHomePage in a MaterialApp widget here to provide Directionality
  runApp(
    const MaterialApp(
      title: 'User Profile App',
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyhomePageState();

// REMOVED: Deleted the incorrectly placed myIsolatedWidget() method from here
}

class MyhomePageState extends State<MyHomePage> {
  // Initialize UserModel with a dummy or initial value
  UserModel _userModel = UserModel(userId: 'temp_user_id');

  // Define the missing fields
  Position? _currentPosition;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobNumController = TextEditingController();
  final TextEditingController _locationDisplayController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobNumController.dispose();
    _locationDisplayController.dispose();
    super.dispose();
  }

  // --- Location Handling ---

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Location services are disabled. Please enable the services')));
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
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
            content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return;
    }
  }

  Future<void> getCurrentLocation() async {
    await _handleLocationPermission();
    if (!mounted) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _locationDisplayController.text = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location retrieved successfully!')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  // --- Firebase Firestore ---

  Future<void> storeUserData(String name, String mobileNumber, Position position) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('traveldata');

      _userModel.name = name;
      _userModel.mobilenumber = mobileNumber;

      await users.doc(userId).set({
        'name': name,
        'mobileNumber': mobileNumber,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      }).then((value) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully!')));
        }
      }).catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save data: $error')));
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User not authenticated. Cannot save data.')));
      }
    }
  }

  // Unified save function (Fixed syntax and merged all parts)
  Future<void> saveProfileData() async {
    // Basic validation
    if (_currentPosition == null || _nameController.text.isEmpty || _mobNumController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all details and get your location.')));
      }
      return;
    }

    // Ensure user is authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logging in anonymously...')));
      }
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
        currentUser = userCredential.user;
        _userModel = UserModel(userId: currentUser!.uid);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anonymous login failed.')));
        }
        return;
      }
    }

    // Trigger the save logic now that we have all data and a user ID
    String userId = currentUser.uid;
    String name = _nameController.text;
    String mobileNum = _mobNumController.text;
    Position currentPosition = _currentPosition!;

    await storeUserData(name, mobileNum, currentPosition);
  }


  @override
  Widget build(BuildContext context) {
    // FIXED: Implemented the build method correctly
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _mobNumController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _locationDisplayController,
                decoration: const InputDecoration(labelText: 'Location'),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: getCurrentLocation,
                child: const Text('Get Current Location'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveProfileData,
                child: const Text('Save Profile Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/


/*import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'pacath/path.as path';


import 'user_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AuthService());
}

class AuthService extends StatelessWidget {
  const AuthService({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

// MyHomePage class setup
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> { // Corrected the State type from UserCredential to MyHomePage
  UserModel _userModel = UserModel();
  //final ImagePicker _picker = ImagePicker();
  File? _selfieFile;
  Position? _currentPosition;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobNumController = TextEditingController(); // This controller was being reused for location display

  @override
  void dispose() {
    _nameController.dispose();
    _mobNumController.dispose();
    super.dispose();
  }

  // --- Location Handling ---

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Location services are disabled. Please enable the services')));
      }
      return; // Added return statements to stop execution if permissions are denied
    }

    LocationPermission permission = await Geolocator.checkPermission();
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
            content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return;
    }
  }

  Future<void> getCurrentLocation() async {
    await _handleLocationPermission();
    if (!mounted) return; // Check mounted again after async call

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        // Optionally update a display field here if needed, but not the phone number field
        // _locationDisplayController.text = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location retrieved successfully!')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }

  // --- Selfie Handling ---

 *//* Future<void> captureSelfie() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (image != null) {
      setState(() {
        _selfieFile = File(image.path);
      });
    }
  }
*//*
  // --- Firebase Storage/Firestore ---

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
     // print("Upload error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: ${e.message}')));
      }
      return null;
    }
  }

  Future<void> storeUserData(String name, String mobileNumber, String selfieUrl, Position position) async {
    // This assumes the user is already authenticated
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('traveldata');

      // Update the user model or use the function parameters directly
      _userModel.name = name;
      _userModel.mobilenumber = mobileNumber;
     // _userModel.selfieUrl = selfieUrl;
      // Note: UserModel needs a Timestamp field for 'createdAt' to use FieldValue.serverTimestamp() effectively
      // I am assuming the UserModel structure I defined in the comments above.

      await users.doc(userId).set({
        'name': _userModel.name,
        'mobileNumber': _userModel.mobilenumber,
        //'selfieUrl': _userModel.selfieUrl,
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(), // Use FieldValue correctly
        },
        'createdAt': FieldValue.serverTimestamp(), // Use FieldValue correctly
        'status': 'active', // Assuming a default status field
      }).then((value) {
        print("User Data Added");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved successfully!')));
        }
      }).catchError((error) {
        print("Failed to add user data: $error");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save data: $error')));
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User not authenticated. Cannot save data.')));
      }
    }
  }

  // Unified save function
  Future<void> saveProfileData() async {
    // Basic validation
    if (_selfieFile == null || _currentPosition == null || _nameController.text.isEmpty || _mobNumController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all details, capture a selfie, and get your location.')));
      return;
    }

    // Ensure user is authenticated
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User is not logged in.')));
      return;
    }

    String userId = currentUser.uid;
    String name = _nameController.text;
    String mobileNum = _mobNumController.text;
    Position currentPosition = _currentPosition!;


    String? selfieUrl = await uploadSelfieToStorage(_selfieFile!, userId);

    if (selfieUrl != null) {
      await storeUserData(
        name,
        mobileNum,
        selfieUrl,
        currentPosition,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload selfie.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 20),

              // Mobile Number Field
              TextField(
                controller: _mobNumController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),

              // Selfie Display/Capture Button
              _selfieFile == null
                  ? const Text('No image selected.')
                  : Image.file(_selfieFile!, height: 200, fit: BoxFit.cover),
             *//* ElevatedButton(
                onPressed: captureSelfie,
                child: const Text('Capture Selfie'),
              ),*//*
              const SizedBox(height: 20),

              // Location Display/Capture Button
              Text(_currentPosition == null
                  ? 'Location not captured.'
                  : 'Location: Lat ${_currentPosition!.latitude.toStringAsFixed(4)}, Lon ${_currentPosition!.longitude.toStringAsFixed(4)}'),
              ElevatedButton(
                onPressed: getCurrentLocation,
                child: const Text('Get Current Location'),
              ),
              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: saveProfileData,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                child: const Text('Save Profile Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
// Assuming user_model.dart looks something like this for context:
/*
class UserModel {
  String? name;
  String? mobilenumber;
  String? selfieUrl;
  Position? position;
  Timestamp? createdAt; // Using Timestamp for Firestore consistency
  String? status;
}
*/