import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vijeesh/page2.dart';
import 'package:vijeesh/user_model.dart'; // Ensure this file exists and UserModel class is defined
import 'app_config.dart';
   //import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'firebase_options.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:vijeesh/user_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// Note: If you don't have user_model.dart working yet, this basic class will prevent errors:
class UserModel {
  final String? name;
  final String? mob;
  final String? status;
  final double? latitude;
  final double? longitude;
  final Timestamp? createdAt;

  UserModel({this.name, this.mob, this.status, this.latitude, this.longitude, this.createdAt});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  MyhomePageState createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _isLoading = true);
    try {
      String fileName = path.basename(image.path);
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      _imageUrl = await snapshot.ref.getDownloadURL();
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image Uploaded: $_imageUrl')));
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentPosition != null)
              Text('Location: Lat ${_currentPosition!.latitude}, Lon ${_currentPosition!.longitude}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: Text(_isLoading ? 'Uploading...' : 'Pick and Upload Image'),
            ),
            if (_imageUrl != null) Image.network(_imageUrl!, width: 100, height: 100),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VerifyPhoneNumberScreen()),
                );
              },
              child: const Text('Go to Phone Auth Screen (Manual Auth)'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Phone Authentication Screen (Handles SMS flow manually) ---

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({Key? key}) : super(key: key);
  @override
  State<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _verificationId = '';
  final TextEditingController _smsController = TextEditingController();
  bool _codeSent = false;

  Future<void> _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto Verification Complete.')));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification Failed: ${e.message}')));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code Sent. Enter manually below.')));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _signInWithSmsCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed In Successfully!')));
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Mydemo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Enter Phone Number (+CC Number)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyPhone,
              child: const Text('Send Code'),
            ),
            if (_codeSent) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _smsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter SMS Code'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithSmsCode,
                child: const Text('Sign In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// A simple screen to show once authenticated
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are successfully authenticated!'),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}








































// Note: Replace the placeholder below with your actual UserModel implementation
// If you don't have user_model.dart working yet, this basic class will prevent errors:
/*
class UserModel {
  final String? name;
  final String? mob;
  final String? status;
  final double? latitude;
  final double? longitude;
  final Timestamp? createdAt;

  UserModel({this.name, this.mob, this.status, this.latitude, this.longitude, this.createdAt});
}

// --- Main Application Entry Point ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BMydemo());
}

class BMydemo extends StatelessWidget {
  const BMydemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire MaterialApp with FirebasePhoneAuthProvider
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        title: 'User Profile App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(), // Start with the home page
      ),
    );
  }
}

// --- MyHomePage Class (Handles location, storage demo, navigates to auth) ---

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyhomePageState createState() => MyhomePageState();
}

class MyhomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle the case where location services are disabled
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String fileName = path.basename(image.path);
      Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      _imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image Uploaded: $_imageUrl')));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile Demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentPosition != null)
                Text('Location: Lat ${_currentPosition!.latitude}, Lon ${_currentPosition!.longitude}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickAndUploadImage,
                child: Text(_isLoading ? 'Uploading...' : 'Pick and Upload Image'),
              ),
              if (_imageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(_imageUrl!, width: 100, height: 100),
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Phone Auth Screen
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VerifyPhoneNumberScreen()),
                  );
                },
                child: const Text('Go to Phone Auth Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Phone Authentication Screen (Handles SMS flow) ---

class VerifyPhoneNumberScreen extends StatefulWidget {
  const VerifyPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() => _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number (+CC Number)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FirebasePhoneAuthHandler(
              phoneNumber: _phoneController.text,
              builder: (context, controller) {
                return ElevatedButton(
                  onPressed: () async {
                    if (_phoneController.text.isEmpty) return;
                    // Trigger the SMS sending process
                    await controller.verifyPhoneNumber();
                  },
                  child: Text(controller.isSendingCode ? 'Sending Code...' : 'Verify Phone Number'),
                );
              },
              onCompleted: (PhoneAuthCredential credential) async {
                // Auto login happens here if successful
                await FirebaseAuth.instance.signInWithCredential(credential);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification Completed! Logged In.')));
                // Navigate to HomeScreen or pop
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              onFailed: (FirebaseAuthException authException) {
                // Handle specific errors like invalid phone number
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification Failed: ${authException.message}')));
              },
              onCodeSent: (String verificationId, int? resendToken) {
                // When code is sent, you usually navigate to a screen to enter the SMS code
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code Sent!')));
                // In a real app, you would pass the verificationId to a new screen for user input
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => EnterSmsCodeScreen(verificationId: verificationId)));
              },
              onAutoRetrievalTimeout: (String verificationId) {
                // Called when SMS auto-retrieval times out
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto Retrieval Timeout.')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// A simple screen to show once authenticated
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are successfully authenticated!'),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
