import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/settings_page.dart';
import 'package:wheres_the_halal/pages/home_page.dart';

class MenuDrawer extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser!;

  MenuDrawer({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.only(bottom: 100.0),
          children: [
            Container(
              height: 175.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green[400]),
                child: Text(
                  'Logged in as: ' + user.email!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                    )
                  ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // update app state
                Navigator.push(context, MaterialPageRoute(builder:(context) => HomePage()));

                
              }
              
            ),
            //   ListTile(
            //   title: const Text('Restaurants Near Me'),
            //   onTap: () {
            //     // update app state
            //     Navigator.pop(context);
            //   }
            // ),
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