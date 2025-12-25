import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

// NOTE: You must generate/provide these files
import 'firebase_options.dart';
import 'user_model.dart'; // Make sure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure you have valid firebase_options.dart configured
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in anonymously.");
    }
  } on Exception catch (e) {
    print("Authentication failed: $e. Ensure Anonymous Auth is enabled in Firebase Console.");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Position? _currentPosition;
  File? _selfieFile;
  String? _selfieUrl;
  final ImagePicker _picker = ImagePicker();

  // Initialize default values for the UI state
  bool _isSwitched = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Method to handle the switch toggle
  void _toggleSwitch(bool value) {
    setState(() {
      _isSwitched = value;
      // Optionally save the new status to Firestore immediately here if needed
    });
  }

  // --- Location Handling ---

  Future<void> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) _showSnackBar('Location services are disabled.');
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _showSnackBar('Location permissions are denied.');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) _showSnackBar('Location permissions are permanently denied.');
      return;
    }
  }

  Future<void> getCurrentLocation() async {
    await _handleLocationPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _locationController.text =
        'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      _showSnackBar('Failed to get location: $e');
    }
  }

  // --- Image Handling ---

  Future<void> _captureSelfie() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selfieFile = File(image.path);
      });
    }
  }

  Future<String?> uploadSelfieToStorage(File file, String userId) async {
    try {
      String fileName = path.basename(file.path);
      Reference storageRef = FirebaseStorage.instance.ref().child(
        'selfies/$userId/$fileName',
      );
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }

  // --- Firestore Operations ---

  Future<void> storeUserData(UserModel userModel) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showSnackBar('User not authenticated. Cannot save data.');
      return;
    }
    CollectionReference users = FirebaseFirestore.instance.collection('traveldata');
    await users
        .doc(userId)
        .set(userModel.toJson())
        .then((value) {
      _showSnackBar('Profile saved successfully!');
    })
        .catchError((error) {
      _showSnackBar('Failed to save data: $error');
    });
  }

  Future<void> saveProfileData() async {
    if (_selfieFile == null || _currentPosition == null || _nameController.text.isEmpty) {
      _showSnackBar('Please complete all fields.');
      return;
    }

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      _showSnackBar('User not authenticated.');
      return;
    }

    _selfieUrl = await uploadSelfieToStorage(_selfieFile!, userId);

    if (_selfieUrl != null) {
      UserModel userModel = UserModel(
        name: _nameController.text,
        mobilenumber: 'N/A', // Placeholder
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        selfieUrl: _selfieUrl,
        status: _isSwitched, userId: '', // Save the current status of the switch
      );
      await storeUserData(userModel);
    } else {
      _showSnackBar('Failed to upload selfie.');
    }
  }

  Future<void> editProfileData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showSnackBar('User not authenticated. Cannot edit data.');
      return;
    }
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter a name to update.');
      return;
    }

    Map<String, dynamic> updates = {
      'name': _nameController.text,
      'status': _isSwitched, // Update the status as well
      'timestamp': FieldValue.serverTimestamp(),
    };

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('traveldata').doc(userId);

    await userDocRef.update(updates).then((_) { // Use (_) for unused parameter
      _showSnackBar('Profile updated successfully!');
    }).catchError((error) {
      _showSnackBar('Failed to update data. Does the profile exist?');
    });
  }

  Future<void> deleteProfileData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      _showSnackBar('User not authenticated. Cannot delete data.');
      return;
    }

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('traveldata').doc(userId);

    await userDocRef.delete().then((_) {
      _showSnackBar('Profile deleted successfully!');
      setState(() {
        _nameController.clear();
        _locationController.clear();
        _selfieFile = null;
        _currentPosition = null;
        _selfieUrl = null;
        _isSwitched = false; // Reset switch status on delete
      });
    }).catchError((error) {
      _showSnackBar('Failed to delete data.');
    });
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Data Entry"),
      ),
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
              // Location Section
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location Coords'),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: getCurrentLocation,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Selfie Section
              ElevatedButton(
                onPressed: _captureSelfie,
                child: const Text('Capture Selfie'),
              ),
              if (_selfieFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(_selfieFile!, height: 150, fit: BoxFit.cover),
                ),
              if (_selfieUrl != null && _selfieFile == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.network(_selfieUrl!, height: 150, fit: BoxFit.cover),
                ),
              const SizedBox(height: 20),

              // Status Switch Section (Correctly implemented in build method)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(' ${_isSwitched ? 'Online' : 'offline'}'),
                  Switch(
                    value: _isSwitched, // Current value from state variable
                    onChanged: _toggleSwitch,  // Callback updates the state variable
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons
              ElevatedButton(
                onPressed: saveProfileData,
                child: const Text('Save Profile (Set)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: editProfileData,
                child: const Text('Update Name/Status (Update)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: deleteProfileData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
