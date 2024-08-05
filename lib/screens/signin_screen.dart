// ignore_for_file: use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:message_app_final/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignInScreen extends StatefulWidget {
  static const String screenRoute = 'signin_screen';

  const SignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 180,
                    child: Image.asset('images/Messages-Logo.png')),
                const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your Email',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    // Use a regular expression for basic email validation
                    String emailRegex =
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                    RegExp regex = RegExp(emailRegex);
                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    // Use a regular expression for basic password validation
                    // This example requires at least 8 characters
                    String passwordRegex = r'^.{8,}$';
                    RegExp regex = RegExp(passwordRegex);
                    if (!regex.hasMatch(value)) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800]!,
                  ),
                  child: const Text('Sign in ',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    // Validate the form fields
                    if (_formKey.currentState!.validate()) {
                      // If validation is successful, save the form
                      _formKey.currentState!.save();

                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        // Attempt to sign in with the provided email and password
                        final userCredential =
                            await _auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // Check if the sign-in was successful
                        if (userCredential.user != null) {
                          // Navigate to the ChatScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatScreen()),
                          );
                        } else {
                          // Handle the case where there is no user with the provided credentials
                          // Show an appropriate error message to the user
                          // For example:
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:const Text('Sign-in Failed'),
                              content:const Text(
                                  'Invalid email or password. Please try again.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                        // Handle sign-in errors here
                        // You might want to show an error message to the user
                        // or perform other error handling actions
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign-in Failed'),
                            content:
                                const Text('An error occurred. Please try other user or another password.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
