import 'package:chat_app/views/RegisterView.dart';
import 'package:chat_app/views/loginView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'views/ChatView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  //const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginWedget.id: (context) => LoginWedget(),
        RegisterWidget.id: (context) => RegisterWidget(),
        ChatView.id: (context) => ChatView(),
      },
      initialRoute: LoginWedget.id,
    );
  }
}
