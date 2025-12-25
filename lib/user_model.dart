



// Ensure you have these imports in your file:
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart'; // You need this package for Position
import 'package:image_picker/image_picker.dart'; // You need this package for ImagePicker


class UserModel {
  // --- Private fields (internal state/helpers) ---
  // Note: These should probably live in your UI/Service layer, not the data model.
  File? _selfieFile;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();

  // --- Fields intended for Firestore serialization ---
   String? name;
  String? mobilenumber;
  final String? userId;
  double? latitude;
  double? longitude;
  String? image; // Holds the URL of the uploaded image
  bool? status; // Generic status field
  final bool isOnline; // Field for the real-time online status
  Timestamp? createdAt;
  String? selfieUrl;

  // A dynamic method placeholder for server timestamp


  // Required parameter

  // Add other fields as needed

  // Update the constructor to require userId
  //UserModel({required this.userId, this.name, required this.isOnline});


  dynamic serverTimestamp() => FieldValue.serverTimestamp();

  // --- Constructor ---
  UserModel({
    this.name,
    this.mobilenumber,
    required this.userId, // userId should probably be required
    this.latitude,
    this.longitude,
    this.image,
    this.status = false, // Default value for general status
    this.isOnline = false, // Default value for online status
    this.createdAt,
    this.selfieUrl,
  });

  // --- Factory constructor to create a UserModel from a Firestore Map ---
  factory UserModel.fromMap(Map<String, dynamic> data, {String? docId}) {
    final dynamic locationData = data['location'];
    double? lat, lng;

    if (locationData is GeoPoint) {
      lat = locationData.latitude;
      lng = locationData.longitude;
    } else if (locationData is Map) {
      lat = (locationData['latitude'] as num?)?.toDouble();
      lng = (locationData['longitude'] as num?)?.toDouble();
    }

    return UserModel(
      name: data['name'] as String?,
      mobilenumber: data['mobilenumber']?.toString(),
      userId: docId ?? data['id'] as String?, // Use document ID if available, otherwise 'id' field
      latitude: lat,
      longitude: lng,
      image: data['selfieUrl'] as String?,
      status: data['status'] as bool?,
      isOnline: data['isOnline'] as bool? ?? false, // Ensure isOnline is mapped
      createdAt: data['createdAt'] as Timestamp?,
      selfieUrl: data['selfieUrl'] as String?, // Fixed potential overwrite of 'image' field
    );
  }

  // --- Methods to convert UserModel to a Map for Firestore upload ---
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mobilenumber": mobilenumber,
      "uid": userId,
      "location": latitude != null && longitude != null
          ? GeoPoint(latitude!, longitude!)
          : null,
      "selfieUrl": selfieUrl ?? image, // Use selfieUrl field
      "status": status,
      "isOnline": isOnline, // Add this field to your database representation
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

// Example of how to use the UserModel elsewhere in your app:

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = "some_actual_user_id_here"; // Get this from your Auth service

  // This is the function that should be called when toggling status:
  Future<void> setStatus(bool isOnline) async {
    if (currentUserId == null) return;

    await _firestore.collection('users').doc(currentUserId).update({
      'isOnline': isOnline,
      'lastSeen': isOnline ? null : FieldValue.serverTimestamp(),
    });
  }
}




/*
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UserModel {
  // --- Private fields (internal state/helpers) ---
  File? _selfieFile;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker();

  // --- Fields intended for Firestore serialization ---
  final String? name;
  String? mobilenumber;
  final String? userId;
  double? latitude;
  double? longitude;
  String? image; // Holds the URL of the uploaded image
  bool? status;
  Timestamp? createdAt;
  String? selfieUrl;
  // Constructor
  UserModel({
    this.name,
    this.mobilenumber,
    this.userId,
    this.latitude,
    this.longitude,
    this.image,
    this.status = false,
    this.createdAt,
    this.selfieUrl,
  });
  dynamic serverTimestamp() => FieldValue.serverTimestamp();
  // 👇 Factory constructor to create a UserModel from a Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    // Note: If Firestore stores coordinates in a GeoPoint *type*,
    // you access the properties differently than accessing a nested Map key.

    // Check if 'location' is stored as a Map OR a GeoPoint object instance
    final dynamic locationData = data['location'];
    double? lat, lng;

    if (locationData is GeoPoint) {
      // Handle if Firestore returns an actual GeoPoint object
      lat = locationData.latitude;
      lng = locationData.longitude;
    } else if (locationData is Map) {
      // Handle if location is stored as a nested Map<String, dynamic>
      lat = (locationData['latitude'] as num?)?.toDouble();
      lng = (locationData['longitude'] as num?)?.toDouble();
    }

    return UserModel(
      name: data['name'] as String?,
      mobilenumber: data['mobilenumber']?.toString(), // Safely converts int to String
      userId: data['id'] as String?, // Assuming Firestore document ID is stored under key 'id'
      latitude: lat,
      longitude: lng,
      image: data['selfieUrl'] as String?,
      status: data['status'] as bool?,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  // Method to convert UserModel to a Map for JSON serialization/Firestore upload
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mobilenumber": mobilenumber,
      "uid": userId,
      // You can store location as a Map or as a Firestore GeoPoint instance
      "location": latitude != null && longitude != null
          ? GeoPoint(latitude!, longitude!) // Use actual GeoPoint type for efficiency
          : null,
      "selfieUrl": image,
      "status": status,
      "createdAt": createdAt ?? FieldValue.serverTimestamp(), // Use server timestamp if null
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'mobileNumber': mobilenumber,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': serverTimestamp(), // Use Firestore's server timestamp
      },
      'createdAt': serverTimestamp(),
      'selfieUrl': selfieUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }




}

*/




/*
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';





class UserModel {
  // --- Private fields not intended for Firestore serialization ---
  // These internal fields should probably not be part of your *model* that represents
  // the data structure saved to the database. They are UI state/helper fields.
  // I'm keeping them here based on your original request but marking them private.
  File? _selfieFile;
  Position? _currentPosition;
  final ImagePicker _picker = ImagePicker(); // Changed to final as per convention


  // --- Fields intended for Firestore serialization ---
  String? name;
  // Firestore usually stores numbers as 'int' or 'num', but mobile numbers
  // are often better stored as Strings to handle leading zeros and international codes.
  String? mobilenumber;
  String? uid; // Changed from int? to String? (Firebase UIDs are strings)

  // Storing Latitude/Longitude as separate strings or doubles in the model works,
  // but often best practice to store them as Doubles for easier querying or as a GeoPoint.
  double? latitude;
  double? longitude;

  String? image; // This will hold the URL of the uploaded image
  int? status;
  // Use Timestamp in the model for better Firestore compatibility when serializing
  Timestamp? createdAt;

  // Constructor
  UserModel({
    this.name,
    this.mobilenumber,
    this.uid,
    this.latitude,
    this.longitude,
    this.image,
    this.status,
    this.createdAt, // Renamed 'createAt' to 'createdAt' for Dart style consistency
  });

  // Factory method to create a UserModel from a JSON (or DocumentSnapshot)
  // Changed parameter type from generic DocumentSnapshot to dynamic Map
  // if you want flexibility, or keep DocumentSnapshot if strictly from Firestore.
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      // Safely access data using null-aware operators if keys might be missing
      name: data['name'] as String?,
      mobilenumber: data['mobileNumber'] as String?, // Match the key used in main.dart
      uid: data['uid'] as String?,
      latitude: (data['location']?['latitude'] as num?)?.toDouble(), // Safely access nested location data
      longitude: (data['location']?['longitude'] as num?)?.toDouble(),
      image: data['selfieUrl'] as String?, // Match the key used in main.dart
      status: data['status'] as int?,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  // Method to convert UserModel to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "mobileNumber": mobilenumber, // Changed key name for consistency
      "uid": uid,
      // Group location data into a sub-map as done in your main.dart code
      "location": {
        "latitude": latitude,
        "longitude": longitude,
        "timestamp": createdAt,
      },
      "selfieUrl": image, // Changed key name for consistency
      "status": status,
      "createdAt": createdAt,
    };
  }
}



class fromMap {



}







*/



























/*
class UserModel {
  File? _selfieFile;
  Position? _currentPosition;
  ImagePicker _picker = ImagePicker();
  String? name;
  int? mobilenumber;
  int? uid;
  String? latitude;
  String? longitude;
  String? image;
  int? status;
  DateTime? createAt;

  // Constructor
  UserModel({
    this.name,
    this.mobilenumber,
    this.uid,
    this.latitude,
    this.longitude, // Corrected typo from "longitue"
    this.image, // Corrected typo from "imgage"
    this.status,
    this.createAt,
  });

  // Factory method to create a UserModel from a JSON (or DocumentSnapshot)
  factory UserModel.fromjson(DocumentSnapshot data) {
    return UserModel(
      name: data['name'],
      mobilenumber: data['mobilenumber'],
      uid: data['uid'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      status: data['status'],
      createAt: data['createAt'],
    );
  }

  // Method to convert UserModel to a Map for JSON serialization
  Map<String, dynamic> tojson() {
    return {
      "name": name,
      "mobile number": mobilenumber,
      "uid": uid,
      "latitude": latitude,
      "longitude": longitude,
      "image": image, // Added image to the tojson method
      "status": status,
      "createdAt":
          createAt, // Changed to match the constructor and data['createAt']
    };
  }
}
*/
