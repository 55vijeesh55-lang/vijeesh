// ... (previous imports and main function code remains the same)
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
import 'user_model.dart';

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
    // Continue running the app even if auth fails, the UI will just show errors when saving data.
  }
  // Optional: Sign in anonymously for testing Firestore rules that require authentication

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp provides the necessary Directionality widget for Scaffold
    return const MaterialApp(
      home: Page5(),
      debugShowCheckedModeBanner: false, // Optional: removes the debug banner
    );
  }
}

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  State<Page5> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Page5> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  Position? _currentPosition;
  File? _selfieFile;
  String? _selfieUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
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
        selfieUrl: _selfieUrl, userId: '',
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
      'timestamp': FieldValue.serverTimestamp(),
    };

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('traveldata').doc(userId);

    await userDocRef.update(updates).then(() {
      _showSnackBar('Profile updated successfully!');
    } as FutureOr<dynamic> Function(void value)).catchError((error) {
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

    await userDocRef.delete().then(() {
      _showSnackBar('Profile deleted successfully!');
      setState(() {
        _nameController.clear();
        _locationController.clear();
        _selfieFile = null;
        _currentPosition = null;
        _selfieUrl = null;
      });
    } as FutureOr<dynamic> Function(void value)).catchError((error) {
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
    // This Scaffold is now correctly wrapped by MyApp's MaterialApp
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Data Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Current Location (Lat/Lon)'),
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  onPressed: getCurrentLocation,
                  tooltip: 'Get Current Location',
                ),
              ],
            ),
            const SizedBox(height: 20),
            _selfieFile == null
                ? const Text('No selfie captured.')
                : Image.file(
              _selfieFile!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            ElevatedButton(
              onPressed: _captureSelfie,
              child: const Text('Capture Selfie'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: saveProfileData,
              child: const Text('Save New Profile Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: editProfileData,
              child: const Text('Update Existing Profile Data (Name only)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteProfileData,
              child: const Text('Delete Profile Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
