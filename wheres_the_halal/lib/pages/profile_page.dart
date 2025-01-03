import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wheres_the_halal/components/textbox.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';
import 'package:wheres_the_halal/pages/forgot_pw_page.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final String pageName = 'Profile';

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final _currentUser = FirebaseAuth.instance.currentUser!;

  // all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // edit field method
  Future<void> editField(String field) async {
    String _newVal = "";
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: TextStyle(color: Colors.white)
          ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey)
          ),
          onChanged: (value) {
            _newVal = value;
          },
          autocorrect: false,
        ),
        actions: [
          // cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () => Navigator.pop(context),
          ),

          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () => Navigator.of(context).pop(_newVal),
          ),
        ],
      ),

    );

    // update in firestore
    if (_newVal.trim().length > 0) {
      // only update if field is non empty
      await usersCollection.doc(_currentUser.email!).update({field: _newVal});
    }
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
      
      // body
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").doc(_currentUser.email!).snapshots(),
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(height: 50),
                
                Icon(
                  Icons.person,
                  size: 80.0
                ),

                const SizedBox(height: 8),

                // current user
                Text(
                  _currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  )
                ),

                MyTextBox(
                  text: userData['username'], 
                  sectionName: 'Username',
                  onPressed: () => editField('username')
                ),

                SizedBox(
                height: 20,
                  ),

                Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  
                  children: [
                    GestureDetector(
                      key: Key('forgot_pw_button'),
                      onTap: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context){
                              return ForgotPasswordPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Change Password',
                          style: TextStyle(
                            color: Colors.blue[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error" + snapshot.error.toString()
              )
            );
          }

          return Center(child: CircularProgressIndicator());
        }
      ) 
    );
  }
}

