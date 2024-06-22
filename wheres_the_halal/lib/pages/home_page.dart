import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // location
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentPosition;

  final String pageName = 'Home';

  @override
  void initState() {
    super.initState();
    fetchLocationUpdates();
    
  }

  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // Sign out button
        actions: [IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:(context) => AuthPage()));
            signUserOut();
          },
          icon: Icon(Icons.logout)
          )
        ],
        // AppBar color and icon color/size
        backgroundColor: Colors.green[600],
        iconTheme: const IconThemeData( 
          color: Colors.black,
          size: 30.0
          ),
        title: Text(pageName),
        ),

      drawer: MenuDrawer(pageName),

      // Rest of homepage 
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              // App name
              const SizedBox(height: 15.0),
              Center(
                child: Text(
                  'Where\'s The Halal',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              const SizedBox(height: 25),

              _currentPosition == null
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ) 
                : Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 1.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: GoogleMap(
                        onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 16
                        ),
                        markers: {
                          // insert list of nearby restaurants as markers here
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: true,
                      ),
                    ),
                  ),


              SizedBox(height: 25,),

              Center(
                child: Text(
                  'Restaurants near me',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ]
          ),
          )
      ),
    );
  }
}
