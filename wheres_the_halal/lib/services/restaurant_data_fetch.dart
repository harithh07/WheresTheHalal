import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantDataFetch {

  final CollectionReference restaurantCollection = FirebaseFirestore.instance.collection('restaurants');

  static List allResults = [];

  static getClientStream() async {
    // order restaurants by name, then by location name
    var data = await FirebaseFirestore.instance.collection('restaurants').orderBy('name').orderBy('location').get();

    allResults = data.docs;
  }

  static Future<List> getRestaurantsInRadius(double radius, LatLng currentPosition) async {
    List nearbyResults = [];

    

    if (allResults.isEmpty) {
      return [];
    }
    else {
      for (var doc in allResults) {
        double dist = getDistance(currentPosition, doc['geolocation']);
        if (dist <= radius) {
                nearbyResults.add(doc);
              }
      }
      nearbyResults.sort((a, b) => Comparable.compare(getDistance(currentPosition, a['geolocation']), 
                                                        getDistance(currentPosition, b['geolocation'])));
      return nearbyResults;
    }
  }

  static double getDistance(LatLng currentPosition, GeoPoint point) {
      return Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, 
              point.latitude, point.longitude);
    }


}