import 'package:flutter/material.dart';
import 'package:message_app_final/screens/chat_screen.dart';
import 'package:message_app_final/screens/registeration_screen.dart';
import 'package:message_app_final/screens/signin_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAtZ-KZ332c2xTDkILBiHIAkq3A45SJl38",
          appId: "1:421761022101:android:a91c509932037f3413439c",
          messagingSenderId: "421761022101",
          projectId: "messageapp-e01ef"));

  runApp(MessageApp());
}

class MessageApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  MessageApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatting Group App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomeScreen(),
      // if he hsa logged be login
      initialRoute:_auth.currentUser!=null? ChatScreen.screenRoute:WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
        SignInScreen.screenRoute: (context) => const SignInScreen(),
        RegistrationScreen.screenRoute: (context) => const RegistrationScreen(),
        ChatScreen.screenRoute: (context) => const ChatScreen(),
      },
    );
  }
}
