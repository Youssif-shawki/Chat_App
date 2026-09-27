import 'package:chat_app/constants.dart';
import 'package:chat_app/models/Message.dart';
import 'package:chat_app/widget/chatBubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  ChatView({super.key});

  static String id = 'ChatView';

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
        );
      }
    });
  }

  void _sendMessage(String data, String email, String userName) {
    if (data.trim().isNotEmpty) {
      messages.add({
        'message': data,
        'createdAt': DateTime.now(),
        'id': email,
        'userName': userName,
      });
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = args['email']!;
    final userName = args['userName']!;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromJson(snapshot.data!.docs[i].data()));
          }
          _scrollToBottom();

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/scholar.png', height: 50),
                  Text('Chat', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (context, i) {
                      return messageList[i].id == email
                          ? ChatBubble(message: messageList[i])
                          : SecondryChatBubble(message: messageList[i]);
                    },
                  ),
                ),

                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      _sendMessage(data, email, userName);
                    },

                    decoration: InputDecoration(
                      hint: Text(
                        'Send Message',
                        style: TextStyle(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _sendMessage(controller.text, email, userName);
                        },
                        icon: Icon(Icons.send, size: 30),
                        color: kPrimaryColor,
                        padding: EdgeInsets.zero,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: kPrimaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}
