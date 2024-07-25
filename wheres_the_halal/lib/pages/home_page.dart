import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheres_the_halal/pages/restaurant_page.dart';
import 'dart:async';

import 'package:wheres_the_halal/services/restaurant_data_fetch.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _user = FirebaseAuth.instance.currentUser!;

  // location
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentPosition;
  List? _nearbyRestaurants;
  Set<Marker> _markers = {};
  bool _locationDisabled = false;
  int? _numOfNearbyRestaurants = 0;

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
        setState(() {
          _locationDisabled = true;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationDisabled = true;
      });
      return Future.error('Location permissions are permanently denied');
    }

    Position pos = await Geolocator.getCurrentPosition();

    setState(() {
      _locationDisabled = false;
      _currentPosition = LatLng(pos.latitude, pos.longitude);
    });

    await fetchNearbyRestaurants();
    await fetchMarkers();
  }

  // fetches list of restaurants in a 3km radius from user
  Future<void> fetchNearbyRestaurants() async {
    setState(() {
      _nearbyRestaurants = [];
    });
    print("fetching nearby restaurants");
    await RestaurantDataFetch.getClientStream();
    List temp = await RestaurantDataFetch.getRestaurantsInRadius(
        3000, _currentPosition!);

    setState(() {
      _nearbyRestaurants = temp;
      _numOfNearbyRestaurants = _nearbyRestaurants?.length;
    });
  }

  //fetches the markers of the restaurants within 3km radius
  Future<void> fetchMarkers() async {
    print("fetching markers");
    Set<Marker> markerSet = {};

    await RestaurantDataFetch.getClientStream();
    List temp = await RestaurantDataFetch.getRestaurantsInRadius(
        3000, _currentPosition!);

    for (var restaurant in temp) {
      markerSet.add(Marker(
          markerId: MarkerId(restaurant.place_id),
          
          position: LatLng(restaurant.geolocation.latitude,
              restaurant.geolocation.longitude),
          infoWindow: InfoWindow(
              title: restaurant.name, 
              snippet: restaurant.location, 
              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantPage(
                                      restaurant: restaurant
                                      )
                                    )))));
    }

    print("Markers fetched: ${markerSet.length}");
    setState(() {
      _markers = markerSet;
    });
  }

  Future<void> refreshPage() async {
    await fetchLocationUpdates();
    final GoogleMapController _controller = await _mapController.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _currentPosition!, zoom: 14.5)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // Sign out button
          actions: [
            IconButton(
                key: Key('signout_button'),
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
          onRefresh: refreshPage,
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

              // check if location services are denied
              // if denied, display button to open location settings
              // if not, check if current position has been obtained
              // if current position is still null, display a loading circle until it is not null
              // if not null, display google maps widget
              _locationDisabled
              ? Center(
                  child: Container(
                    width: 410,
                    height: 300,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => Geolocator.openLocationSettings(),
                        child: Container(
                          height: 120,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Enable location settings to see restaurants near you",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0
                              ),
                              textAlign: TextAlign.center,
                            ),

                          )
                        )
                      )
                    ),
                  ),
                )
              : _currentPosition == null
                  ? Center(
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1.0),
                        ),
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.black)),
                      ),
                    )
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
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
                                  target: _currentPosition!, zoom: 14.5),
                              markers: _markers
                              // TODO: insert list of nearby restaurants as markers here
                              ,
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
                  ),

              SizedBox(
                height: 20,
              ),

              
              _locationDisabled 
              ? SizedBox()
              : Center(
                child: Column(
                  children: [
                    Text('Restaurants near me',
                        style:
                            TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)
                        ),
                    SizedBox(height: 3),

                    Text('$_numOfNearbyRestaurants restaurants nearby')
                  ],
                ),
              ),

              SizedBox(height: 10),

              // displays list of nearby restaurants
              _locationDisabled 
                ? SizedBox()
                : _nearbyRestaurants == null
                  ? Center(
                      // child: Container(
                      //   height: 50,
                      //   child: CircularProgressIndicator(),
                      // ),
                      )
                  : Container(
                      height: 250,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                                color: Colors.black,
                                thickness: 0.5,
                                height: 0.0),
                        shrinkWrap: true,
                        itemCount: _nearbyRestaurants!.length,
                        itemBuilder: (context, index) {
                          String distDisplay = "";
                          double dist = (RestaurantDataFetch.getDistance(
                            _currentPosition!, 
                            _nearbyRestaurants![index].geolocation
                          ) / 1000);
                          if (dist < 0.05) {
                            distDisplay = "Less than 50m away";
                          } else {
                            distDisplay = dist.toStringAsPrecision(2) + " km away";
                          }
                          
                          return ListTile(
                            title: Text(_nearbyRestaurants![index].name),
                            subtitle: Text(
                              distDisplay
                            ),
                            trailing: _nearbyRestaurants![index].cuisine != null
                              ? Text(_nearbyRestaurants![index].cuisine)
                              : Text(""),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantPage(
                                        restaurant:
                                            _nearbyRestaurants![index]))),
                          );
                        },
                      ),
                    )
            ]),
          )),
        ));
  }
}
