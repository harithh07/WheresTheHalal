import 'dart:convert';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:wheres_the_halal/components/constants.dart';
import 'package:wheres_the_halal/components/my_button.dart';

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
  List _reviews = [];
  List _mostRelevantReviews = [];
  List _newestReviews = [];
  double? _rating;

  // launch location in google maps to find directions
  void launchMap() async {
    String query = Uri.encodeComponent(
        widget.restaurant.name + ", " + widget.restaurant.location);
    String queryPlaceId = Uri.encodeComponent(widget.restaurant.place_id);
    Uri url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$query&query_place_id=$queryPlaceId");

    // if (Platform.isIOS) {
    //   url = Uri.parse("http://maps.apple.com/?q=$query");
    // }

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void launchPhone() async {
    if (widget.restaurant.contact is! double) {
      String _contactNumber = widget.restaurant.contact;
      String query = Uri.encodeComponent(_contactNumber);

      Uri url = Uri.parse('tel: +65 $query');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  // launch all reviews in google
  void launchReviews() async {
    String query = Uri.encodeComponent(
        widget.restaurant.name + ", " + widget.restaurant.location);
    String queryPlaceId = Uri.encodeComponent(widget.restaurant.place_id);
    Uri url = Uri.parse(
        'https://search.google.com/local/reviews?query=$query&placeid=$queryPlaceId');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> getData() async {
    String queryPlaceId = Uri.encodeComponent(widget.restaurant.place_id);
    String apiKey = Uri.encodeComponent(Constants.google_api_key);
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$queryPlaceId&reviews_sort=most_relevant&key=$apiKey&fields=name,rating,reviews';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _mostRelevantReviews = data['result']['reviews'];
        _reviews = _mostRelevantReviews;
        _rating = data['result']['rating'].toDouble();
      });
    } else {
      throw Exception("Failed to load reviews");
    }

    final newRequest =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$queryPlaceId&reviews_sort=newest&key=$apiKey&fields=name,rating,reviews';
    final newResponse = await http.get(Uri.parse(newRequest));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(newResponse.body);
      setState(() {
        _newestReviews = data['result']['reviews'];
      });
    } else {
      throw Exception("Failed to load reviews");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                SizedBox(height: 20.0),

                // Restaurant name
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 15.0),
                  child: Text(widget.restaurant.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0)),
                ),

                SizedBox(height: 10.0),

                Divider(
                  color: Colors.green[800],
                  thickness: 2.0,
                ),

                SizedBox(height: 10.0),

                // cuisine
                widget.restaurant.cuisine != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                            child: Text(widget.restaurant.cuisine,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.green)),
                      )
                    : SizedBox(height: 10.0),

                SizedBox(height: 12.0),

                // location
                Row(children: [
                  SizedBox(width: 35.0),
                  Icon(Icons.location_on, size: 28),
                  SizedBox(width: 8.0),
                  Text(widget.restaurant.location,
                      style: TextStyle(color: Colors.black, fontSize: 18.0)),
                  SizedBox(width: 8.0),
                  GestureDetector(
                      child: Icon(Icons.directions, size: 30),
                      onTap: () => launchMap())
                ]),

                SizedBox(height: 10.0),

                // contact number
                widget.restaurant.contact is! double 
                  ? Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: GestureDetector(
                        // open contact number in phone app
                        onTap: () => launchPhone(),
                        child: Text(
                          widget.restaurant.contact,
                          style: TextStyle(
                            fontSize: 18.0,
                            //fontWeight: FontWeight.bold,
                            color: Colors.blue
                          )
                        ),
                      )
                    )
                  : SizedBox(height: 0),

                SizedBox(height: 10.0),

                // restaurant overall rating
                Container(
                    width: 225,
                    child: _rating != null
                        ? StarRating(
                            size: 30, rating: _rating!, color: Colors.green)
                        : SizedBox(height: 30)),

                SizedBox(height: 20.0),

                // address
                Center(
                  child: Container(
                      width: 350.0,
                      child: Text(widget.restaurant.address,
                          style: TextStyle(fontSize: 16.0)))),

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
                            onMapCreated: ((GoogleMapController controller) =>
                                _mapController.complete(controller)),
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    widget.restaurant.geolocation.latitude,
                                    widget.restaurant.geolocation.longitude),
                                zoom: 17),
                            markers: {
                              Marker(
                                markerId: MarkerId(widget.restaurant.name),
                                position: LatLng(
                                    widget.restaurant.geolocation.latitude,
                                    widget.restaurant.geolocation.longitude),
                              )
                            },
                            myLocationButtonEnabled: false,
                          ),
                        ))),

                SizedBox(
                  height: 25,
                ),

                // google reviews
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text('Reviews',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ),

                SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        'Sort by', 
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      SizedBox(width: 8),

                      DropdownMenu(
                        onSelected: (val) {
                          setState(() {
                            _reviews = val!;
                          });
                        },
                        dropdownMenuEntries: [
                          DropdownMenuEntry(
                            value: _mostRelevantReviews, 
                            label: 'Most relevant'
                          ),
                          DropdownMenuEntry(
                            value: _newestReviews, 
                            label: 'Newest'
                          )
                        ],
                        width: 175,
                        initialSelection: _mostRelevantReviews,
                        inputDecorationTheme: InputDecorationTheme(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          isDense: true,
                          constraints: BoxConstraints.tight(Size.fromHeight(35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        ),
                        
                        
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                
                Divider(color: Colors.black, thickness: 1, height: 0.0),

                // list of reviews
                Container(
                  height: 425,
                  child: ListView.separated(
                      itemCount: _reviews.length,
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                              color: Colors.black, thickness: 0.5, height: 0.0),
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        final rate = review['rating'];
                        final time = review['relative_time_description'];
                        return ListTile(
                            title: Text(review['author_name']),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rating: $rate / 5 - $time'),
                                  Text(review['text'], style: TextStyle(color: Colors.black))
                                ]));
                      }),
                ),
                Divider(color: Colors.black, thickness: 1, height: 0.0),

                SizedBox(height: 50),

                MyButton(onTap: () => launchReviews(), text: 'More reviews'),

                SizedBox(height: 10)
            ])
          ],
        ));
  }
}
