import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/settings_page.dart';
import 'package:wheres_the_halal/pages/home_page.dart';
import 'package:wheres_the_halal/pages/search_page.dart';

class MenuDrawer extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser!;

  MenuDrawer({
    super.key,
  });

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
                Navigator.push(context, MaterialPageRoute(builder:(context) => HomePage()));
              }
            ),
            // search page
            ListTile(
              title: const Text('Search'),
              onTap: () {
                // update app state
                Navigator.push(context, MaterialPageRoute(builder:(context) => SearchPage()));
                // Navigator.pop(context);
              }
            ),
            // settings page
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // update app state
                Navigator.push(context, MaterialPageRoute(builder:(context) => SettingsPage()));
              }
            ),
          ]
        )
      );
  }
}