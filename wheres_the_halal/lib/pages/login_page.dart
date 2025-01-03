import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheres_the_halal/components/login_textfield.dart';
import 'package:wheres_the_halal/components/my_button.dart';
import 'package:wheres_the_halal/components/square_tile.dart';
import 'package:wheres_the_halal/pages/forgot_pw_page.dart';
import 'package:wheres_the_halal/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // TODO: Auth sign in with Firebase

    // show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
        ); 
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
      );
      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      
      // show error message
      showErrorMessage(e.code);
      
    }
  }

    // error message
    void showErrorMessage(String message) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              
              // logo
              Image.asset("lib/images/wth logo.png", height: 300,),

              
              // welcome back
              Text('Welcome back!',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 20,
                  )),
            
              const SizedBox(height: 25),
            
              // email textfield
              LoginTextfield(
                key: Key('email_controller'),
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
              ),
            
              const SizedBox(height: 10),
            
              // password textfield
              LoginTextfield(
                key: Key('pw_controller'),
                controller: _passwordController,
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
                        'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue[500],
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
              const SizedBox(height: 25),
            
              // sign in button
            
              MyButton(
                text: "Sign In",
                onTap: signUserIn,
                key: Key('signin_button')
                ),
            
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
              Center(
                  child: SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google.png', height: 64.0
                      )),
            
              const SizedBox(height: 20),
            
              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      )),
                  ),
              ])
            ]),
          ),
        )));
  }
}
