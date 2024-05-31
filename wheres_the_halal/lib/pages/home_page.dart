import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/pages/auth_page.dart';
import 'package:wheres_the_halal/components/menu_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final String pageName = 'Where\'s the Halal';

  // sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      // App Bar
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
        title: Text(
          pageName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30
            ),
          ),
        ),

      drawer: MenuDrawer(),

      // Rest of homepage 
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // // App name
              // const SizedBox(height: 15.0),
              // Text(
              //   'Where\'s The Halal',
              //   style: TextStyle(
              //     color: Colors.green[600],
              //     fontSize: 36.0,
              //     fontWeight: FontWeight.bold
              //   )
              // ),


              // const SizedBox(height: 25.0),
              const SizedBox(height: 25.0),
              
              
              // TODO: rest of page

              Container(
              height: 200, //MediaQuery.of(context).size.height * 0.2,
              width:  365, //MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3)
              ),
              child: Container (
                child: Image.asset(
                  'lib/images/googlemap.png'
                  ),
                ),
              ),

              const SizedBox(height: 25.0),

              const Text(
                'Restaurant\'s Near Me',
                style: TextStyle(
                  fontSize: 25.0, 
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25.0),

              Container(
                width: 350,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'McDonald\'s',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: (){},
                    child: const Text(
                      '267 Serangoon Ave 3, #01-37',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      )),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: (){},
                    child: const Text(
                      'Contact Restaurant',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      )),
                  ),
                  SizedBox(height: 5),
                  Text('Open 24 Hours'),
                  SizedBox(height: 5),
                  Text('0.3km away'),
                ],
              ),
            ),

            const SizedBox(height: 25.0),

            Container(
              width: 350,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wok Hey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: (){},
                    child: const Text(
                      '23 Serangoon Central, #B2-10, NEX',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      )),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: (){},
                    child: const Text(
                      'Contact Restaurant',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      )),
                  ),
                  SizedBox(height: 5),
                  Text('Open 24 Hours'),
                  SizedBox(height: 5),
                  Text('0.65km away'),
                ],
              ),
            ),



            ],
          ),
        ),
      ),
    );
  }
}
