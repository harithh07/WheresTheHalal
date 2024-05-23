import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/home_page.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';

class SettingsPage extends StatelessWidget {

  SettingsPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

    void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // Sign out button
        actions: [IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder:(context) => AuthPage()));
            signUserOut();
          },
          icon: Icon(Icons.logout)
          )
        ],

        // AppBar color and icon color/size
        backgroundColor: Colors.green[600],
        iconTheme: const IconThemeData( 
          color: Colors.black,
          size: 30.0
          ),
        ),

      // drawer menu
      drawer: Drawer(
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
                Navigator.pop(context);
              }
            ),
          ]
        )
      ),
      
      // Rest of homepage 
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              // App name
              const SizedBox(height: 15.0),
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 225.0),
              Text(
                'WIP',
                style: TextStyle(fontSize: 50.0)
              )

            ]
          ),
          )
      ),
    );
  }
}