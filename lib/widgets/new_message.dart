import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
final _firebase = FirebaseAuth.instance;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitmessage() async {
   // try{
   //   Uri uri = Uri.parse('http://localhost:8000/gowrish');
   //   final response = await http.post(uri, body: {
   //     'message': "hii",
   //     'first_time_login': true.toString(),
   //   });
   //   print(response.statusCode);
   // } on Exception{
   //   print("errorr...");
   // }
    final apiUrl = Uri.parse('http://127.0.0.1:8000/insert'); // Replace with your API endpoint
    final headers = <String, String>{
      'Content-Type': 'application/json', // Set the appropriate content type
    };

    final Map<String, dynamic> data = {
      'img_path': '"C:\Users\gowrish varma\Downloads\Zephyrus.png.url"',
      'msg': 'hiii',
    };

    final response = await http.post(
      apiUrl,
      headers: headers,
      body: jsonEncode(data),
    );

    // final response = await http.get(Uri.parse('http://127.0.0.1:8000'));

    final enteredmessage = _messageController.text;
    if (enteredmessage.trim().isEmpty) {
      return;
    }
        FocusScope.of(context).unfocus();
        _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    final userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredmessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userdata.data()!['username'],
      'userImage': userdata.data()!['image_url'],
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              onPressed: _submitmessage,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
    );
  }
}
