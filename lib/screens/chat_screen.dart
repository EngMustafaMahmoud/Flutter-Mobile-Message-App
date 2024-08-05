// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_app_final/screens/welcome_screen.dart';

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

late User signedInUser; // email

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? messageText; // message
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Image.asset('images/Messages-Logo.png', height: 25),
            const SizedBox(width: 10),
            const Text('MessageMe',style: TextStyle(color: Colors.white),)
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              // Navigator.pop(context);
              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy("time").snapshots(),
                builder: (context, snapshot) {
                  List<MessageLine> messageWidgets = []; // all messages
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ));
                  }

                  //obtain data
                  final messages = snapshot.data!.docs; // null check
                  for (var message in messages) {
                    final messageText = message.get('text');
                    final messageSender =
                        message.get('sender'); //  sender email
                    final currentUser = signedInUser.email; // signed in email

                    final messageWidget = MessageLine(
                      sender: messageSender,
                      text: messageText,
                      isme: currentUser == messageSender,
                    );
                    messageWidgets.add(messageWidget);
                  }

                  return Expanded(
                      child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    children: messageWidgets,
                  ));
                }),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 106, 145, 193),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    //obtain message and user email
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                          {"text": messageText, "sender": signedInUser.email,"time":FieldValue.serverTimestamp()});
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.sender, this.text, required this.isme, super.key});
  final String? sender;
  final String? text;
  final bool isme;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '$sender',
              style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
            ),

            // design message shape
            Material(
                elevation: 5,
                borderRadius: isme
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                color: isme
                    ? Colors.blue[800]
                    : const Color.fromARGB(255, 115, 135, 130),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    '$text',
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                )),
          ],
        ));
  }
}
