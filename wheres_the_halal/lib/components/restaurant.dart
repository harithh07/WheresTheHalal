import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String name;
  String cuisine;
  String address;
  String location;
  GeoPoint geolocation;

  Restaurant({
    required this.name,
    required this.cuisine,
    required this.address,
    required this.location,
    required this.geolocation
  });

  
}