import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class RestaurantPage extends StatefulWidget {

  final restaurant;

  RestaurantPage({
    required this.restaurant,
    super.key,
  });

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {

  final Completer<GoogleMapController> _mapController = Completer();
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(widget.restaurant.name),
        ),
        
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),

          // Restaurant name
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0),
            child: Text(
              widget.restaurant.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 36.0
              )
            ),
          ),

          SizedBox(height: 10.0),

          Divider(color: Colors.green[800], thickness: 2.0,),

          SizedBox(height: 10.0),
          
          // cuisine
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              child: Text(
                widget.restaurant.cuisine,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0
                )
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.green
                
              )
            ),
          ),

          SizedBox(height: 12.0),

          // location
          Row(
            children: [
              SizedBox(width: 20.0),
              Icon(Icons.location_on),
              SizedBox(width: 6.0),
              Text(
                widget.restaurant.location,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0
                )
              ),
            ]
          ),

          SizedBox(height: 40.0),

          // address
          Center(
            child: Container(
              width: 350.0,
              child: Text(
                widget.restaurant.address, 
                style: TextStyle(fontSize: 16.0)
              )
            )
          ),

          SizedBox(height: 5.0),

          // google maps location
          Center(
            child: Container(
              width: 350.0,
              height: 350.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1.0),
                
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: GoogleMap(
                  onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.restaurant.geolocation.latitude, widget.restaurant.geolocation.longitude),
                    zoom: 16
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.restaurant.name),
                      position: LatLng(widget.restaurant.geolocation.latitude, widget.restaurant.geolocation.longitude),
                      icon: BitmapDescriptor.defaultMarker
                      
                    )
                  },
                  
                ),
              )
            )
          )


        ],
      )
    );
  }
}