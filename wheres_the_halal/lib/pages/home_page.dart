import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:wheres_the_halal/services/restaurant_data_fetch.dart';

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
  List? nearbyRestaurants;

  final String pageName = 'Home';

  @override
  void initState() {
    super.initState();
    fetchLocationUpdates();
  }


  // @override
  // void didChangeDependencies() {
  //   fetchNearbyRestaurants();
  //   super.didChangeDependencies();
  // }

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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position pos = await Geolocator.getCurrentPosition();
    
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });

    fetchNearbyRestaurants();

  }

  // fetches list of restaurants in a 3km radius from user
  Future<void> fetchNearbyRestaurants() async {
    await RestaurantDataFetch.getClientStream();
    List temp = await RestaurantDataFetch.getRestaurantsInRadius(3000, _currentPosition!);

    setState(() {
      nearbyRestaurants = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // Sign out button
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AuthPage()));
                  signUserOut();
                },
                icon: Icon(Icons.logout)),
          ],
          // AppBar color and icon color/size
          backgroundColor: Colors.green[600],
          iconTheme: const IconThemeData(color: Colors.black, size: 30.0),
          title: Text(pageName),
        ),
        drawer: MenuDrawer(pageName),

        // Rest of homepage
        body: RefreshIndicator(
          onRefresh: fetchLocationUpdates,
          color: Colors.black,
          backgroundColor: Colors.green,
          child: SafeArea(
              child: Center(
            child: ListView(children: [
              // App name
              const SizedBox(height: 15.0),
              Center(
                child: Text('Where\'s The Halal',
                    style: TextStyle(
                        color: Colors.green[600],
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 25),
              // check if current position has been obtained
              // if current position is still null, display a loading circle until it is not null
              // if not null, display google maps widget
              _currentPosition == null
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(width: 1.0),
                      ),
                      // ClipRRect to give GoogleMaps a rounded border
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: GoogleMap(
                            onMapCreated: ((GoogleMapController controller) =>
                                _mapController.complete(controller)),
                            initialCameraPosition: CameraPosition(
                                target: _currentPosition!, zoom: 16),
                            markers: {
                              // TODO: insert list of nearby restaurants as markers here
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: true, // Android only
                            zoomGesturesEnabled: true,
                            tiltGesturesEnabled: true,
                            gestureRecognizers:
                                <Factory<OneSequenceGestureRecognizer>>[
                              new Factory<OneSequenceGestureRecognizer>(
                                  () => new EagerGestureRecognizer()),
                            ].toSet()),
                      ),
                    ),

              SizedBox(
                height: 20,
              ),

              Center(
                child: Text('Restaurants near me',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
              ),

              SizedBox(
                height: 20
              ),

              // displays list of nearby restaurants
              nearbyRestaurants == null ? 
                Center(child: CircularProgressIndicator()) :
                Container(
                  height: 250,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => 
                      const Divider(color: Colors.black, thickness: 0.5, height: 0.0),
                    shrinkWrap: true,
                    itemCount: nearbyRestaurants!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(nearbyRestaurants![index]['name']),
                        subtitle: Text(
                          (RestaurantDataFetch.getDistance(_currentPosition!, nearbyRestaurants![index]['geolocation'])/1000)
                            .toStringAsPrecision(2) + 'km away'
                        ),
                        trailing: Text(nearbyRestaurants![index]['cuisine']),
                      );
                    },
                  ),
                )
            ]),
          )),
        ));
  }
}
