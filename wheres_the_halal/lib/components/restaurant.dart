import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String name;
  String? cuisine;
  String address;
  String location;
  GeoPoint geolocation;
  String place_id;
  var contact;


  Restaurant({
    required this.name,
    this.cuisine,
    required this.address,
    required this.location,
    required this.geolocation,
    required this.place_id,
    required this.contact
  });

  
}