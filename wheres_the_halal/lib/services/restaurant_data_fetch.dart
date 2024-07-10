import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheres_the_halal/components/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDataFetch {

  final CollectionReference restaurantCollection = FirebaseFirestore.instance.collection('restaurants');

  static List temp = [];
  static List allResults = [];

  static getClientStream() async {
    // order restaurants by name, then by location name
    allResults = [];
    var data = await FirebaseFirestore.instance.collection('restaurants').orderBy('name').orderBy('location').get();

    temp = data.docs;
    for (var doc in temp) {
      allResults.add(Restaurant(name: doc['name'], cuisine: doc['cuisine'], address: doc['address'], location: doc['location'], geolocation: doc['geolocation']));
    }
  }

  static Future<List> getRestaurantsInRadius(double radius, LatLng currentPosition) async {
    List nearbyResults = [];

    if (temp.isEmpty) {
      return [];
    }
    else {
      for (var restaurant in allResults) {
        double dist = getDistance(currentPosition, restaurant.geolocation);
        if (dist <= radius) {
                nearbyResults.add(restaurant);
              }
      }
      nearbyResults.sort((a, b) => Comparable.compare(getDistance(currentPosition, a.geolocation), 
                                                        getDistance(currentPosition, b.geolocation)));
      return nearbyResults;
    }
  }

  static double getDistance(LatLng currentPosition, GeoPoint point) {
      return Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, 
              point.latitude, point.longitude);
    }


}