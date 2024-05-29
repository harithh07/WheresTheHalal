import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';

class SettingsPage extends StatelessWidget {

  SettingsPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final String pageName = 'Settings';

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
        title: Text(pageName)
        ),

      // drawer menu
      drawer: MenuDrawer(pageName),
      
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
              // TODO: Rest of page
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