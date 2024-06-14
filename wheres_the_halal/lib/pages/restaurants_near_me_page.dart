import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';

class RestaurantsNearMePage extends StatefulWidget {

  RestaurantsNearMePage({super.key});

  @override
  State<RestaurantsNearMePage> createState() => _RestaurantsNearMePageState();
}

class _RestaurantsNearMePageState extends State<RestaurantsNearMePage> {
  final _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer();
  final String pageName = 'Restaurants Near Me';

  LatLng? _currentPosition;
  
  @override
  void initState() {
    super.initState();
    fetchLocationUpdates();
    
  }

  // get the user's current location
  Future<void> fetchLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentPosition!);
        });
      }
    });
  }

  // centre the camera on the user's current location when moving
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos, 
      zoom: 16
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition), 
    );
  }


  // BUG: page fails to load when app is first opened until hot restarted, or when page is reopened from drawer
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // drawer
      drawer: MenuDrawer(pageName),
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData( 
          color: Colors.black,
          size: 30.0
          ),
        title: Text(pageName)
      ),
      // set camera to current position
      body: _currentPosition == null
       ? const Center(
        child: CircularProgressIndicator(color: Colors.black),
       ) 
       : GoogleMap(
        onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 16
        ),
        markers: {
          // place marker at current position
          Marker(
            markerId: MarkerId("source"),
            position: _currentPosition!,
            icon: BitmapDescriptor.defaultMarker
            
          )
        }
      )
    );
    
  }
}