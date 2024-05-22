import 'package:flutter/material.dart';
import 'package:wheres_the_halal/components/login_textfield.dart';
import 'package:wheres_the_halal/components/my_button.dart';
import 'package:wheres_the_halal/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {
    // TODO: Auth sign in with Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
          child: Column(children: [
            const SizedBox(height: 50),
            // logo
            const Icon(Icons.lock, size: 100),

            const SizedBox(height: 50),
            // welcome back
            Text('Welcome back!',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 20,
                )),

            const SizedBox(height: 25),

            // username textfield
            LoginTextfield(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            LoginTextfield(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // forgot password?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]))
                ],
              ),
            ),

            const SizedBox(height: 25),

            // sign in button

            MyButton(onTap: signUserIn),

            const SizedBox(height: 30),

            // or continue with
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[600],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text('Or continue with',
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // google sign in button
            const Center(
                child: SquareTile(
                    imagePath: 'lib/images/google.png', height: 64.0)),

            const SizedBox(height: 50),

            // not a member? register now
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Not a member?'),
              const SizedBox(width: 4),
              Text('Register now',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  )),
            ])
          ]),
        )));
  }
}
