import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';

class RestaurantsNearMePage extends StatefulWidget {

  RestaurantsNearMePage({super.key});

  @override
  State<RestaurantsNearMePage> createState() => _RestaurantsNearMePageState();
}

class _RestaurantsNearMePageState extends State<RestaurantsNearMePage> {
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
    // PermissionStatus permissionGranted;
    LocationPermission permission;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Error');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Perm disabled');
    }

    Position pos = await Geolocator.getCurrentPosition();

    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });
  }
    

  // centre the camera on the user's current location when moving
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos, 
      zoom: await controller.getZoomLevel()
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition), 
    );
  }

  void _updatePosition() {
    fetchLocationUpdates();
    _cameraToPosition(_currentPosition!);
  }

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
        title: Text(pageName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Builder(
              builder: (context) {
                return IconButton(
                    // opens filter page
                    onPressed: () => _updatePosition(), //Scaffold.of(context).openEndDrawer(),
                    icon: Icon(Icons.refresh),
                    iconSize: 36,
                  );
              }
            ),
          ),
        ],
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
          // Marker(
          //   markerId: MarkerId("currentPosition"),
          //   position: _currentPosition!,
          //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          // )
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        
      )
    );
    
  }
}