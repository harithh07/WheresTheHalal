// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:math';

// class MapPage extends StatefulWidget {
//   MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final Location _locationController = Location();
//   Completer<GoogleMapController> _mapController = Completer();
//   final String pageName = 'Restaurants Near Me';
//   LatLng? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     fetchLocationUpdates();
//   }

//   // Get the user's current location
//   Future<void> fetchLocationUpdates() async {
//     bool _serviceEnabled;
//     PermissionStatus permissionGranted;

//     _serviceEnabled = await _locationController.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await _locationController.requestService();
//       if (!_serviceEnabled) {
//         return; // Handle case where user declines to enable location service
//       }
//     }

//     permissionGranted = await _locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return; // Handle case where user declines to grant location permission
//       }
//     }

//     _locationController.onLocationChanged.listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null && currentLocation.longitude != null) {
//         setState(() {
//           _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentPosition!);
//         });
//       }
//     });
//   }

//   // Center the camera on the user's current location when moving
//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: pos,
//       zoom: 16,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }

//   // Query Firestore for nearby restaurants within 1 kilometer radius
//   Future<List<DocumentSnapshot<Map<String, dynamic>>>> getNearbyRestaurants(LatLng userLocation) async {
//     // Radius of 1 kilometer in meters
//     double radius = 1000;

//     // Firestore collection reference
//     CollectionReference restaurantsRef = FirebaseFirestore.instance.collection('restaurants');

//     // Create a GeoPoint representing the user's location
//     GeoPoint center = GeoPoint(userLocation.latitude, userLocation.longitude);

//     // Calculate bounding box for the query
//     GeoPoint lesserGeopoint = _calculateGeoPointFromRadius(center, -radius);
//     GeoPoint greaterGeopoint = _calculateGeoPointFromRadius(center, radius);

//     // Perform the query
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await restaurantsRef
//         .where('geolocation', isGreaterThan: lesserGeopoint)
//         .where('geolocation', isLessThan: greaterGeopoint)
//         .get() as QuerySnapshot<Map<String, dynamic>>; // Explicit cast to QuerySnapshot<Map<String, dynamic>>


//     return querySnapshot.docs;
//   }

//   // Helper method to calculate GeoPoint with given radius
//   GeoPoint _calculateGeoPointFromRadius(GeoPoint center, double radiusInMeters) {
//     // Haversine formula constants
//     const double R = 6371000.0; // Earth radius in meters

//     double lat1 = center.latitude * (3.141592653589793 / 180);
//     double lon1 = center.longitude * (3.141592653589793 / 180);

//     double brng = 0.0; // Bearing is 0 degrees

//     // Convert distance to the same units as the radius of the Earth (meters)
//     double dist = radiusInMeters / R;

//     double lat2 = asin(sin(lat1) * cos(dist) + cos(lat1) * sin(dist) * cos(brng));
//     double lon2 = lon1 + atan2(sin(brng) * sin(dist) * cos(lat1), cos(dist) - sin(lat1) * sin(lat2));

//     return GeoPoint(lat2 * (180 / 3.141592653589793), lon2 * (180 / 3.141592653589793));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         iconTheme: const IconThemeData(color: Colors.black, size: 30.0),
//         title: Text(pageName),
//       ),
//       body: _currentPosition == null
//           ? const Center(
//               child: CircularProgressIndicator(color: Colors.black),
//             )
//           : FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
//               future: getNearbyRestaurants(_currentPosition!),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator(color: Colors.black));
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else {
//                   List<DocumentSnapshot<Map<String, dynamic>>> nearbyRestaurants = snapshot.data!;
//                   return GoogleMap(
//                     onMapCreated: ((GoogleMapController controller) {
//                       _mapController.complete(controller);
//                     }),
//                     initialCameraPosition: CameraPosition(
//                       target: _currentPosition!,
//                       zoom: 16,
//                     ),
//                     markers: Set<Marker>.from(
//                       nearbyRestaurants.map(
//                         (DocumentSnapshot<Map<String, dynamic>> restaurant) {
//                           GeoPoint location = restaurant['geolocation']!;
//                           LatLng position = LatLng(location.latitude, location.longitude);
//                           return Marker(
//                             markerId: MarkerId(restaurant.id),
//                             position: position,
//                             infoWindow: InfoWindow(title: restaurant['name']), // Assuming 'name' is a field in your restaurant document
//                             icon: BitmapDescriptor.defaultMarker,
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//     );
//   }
// }
