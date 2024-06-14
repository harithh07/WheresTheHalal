import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/restaurants_near_me_page.dart';
import 'package:wheres_the_halal/pages/settings_page.dart';
import 'package:wheres_the_halal/pages/home_page.dart';
import 'package:wheres_the_halal/pages/search_page.dart';

class MenuDrawer extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser!;
  final String pageName;

  MenuDrawer(
    this.pageName, 
    {super.key}
  );
  

  // TODO: Update drawer such that opening a page does not
  // create a new instance eg. pressing Home when already at
  // Homepage does not create a new Homepage instance
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.only(bottom: 100.0),
          children: [
            // show user email
            Container(
              height: 175.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green[400]),
                child: Text(
                  'Logged in as: ' + user.email!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    )
                  ),
              ),
            ),
            // home page
            ListTile(
              title: const Text('Restaurant\'s Near Me'),
              onTap: () {
                // update app state
                if (pageName == 'Home') {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => HomePage()));
                }
              }
            ),
            // Restaurants near me page
            // ListTile(
            //   title: const Text('Restaurants Near Me'),
            //   onTap: () {
            //     // update app state
            //     if (pageName == 'Restaurants Near Me') {
            //       Navigator.pop(context);
            //     } else {
            //       Navigator.push(context, MaterialPageRoute(builder:(context) => RestaurantsNearMePage()));
            //     }
            //   }
            // ),
            // search page
            ListTile(
              title: const Text('Search'),
              onTap: () {
                // update app state
                if (pageName == 'Search') {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SearchPage()));
                }
              }
            ),
              
            // settings page
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // update app state
                if (pageName == 'Settings') {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => SettingsPage()));
                }
              }
            ),
          ]
        )
      );
  }
}