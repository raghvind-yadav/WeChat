import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/constants.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  // It is used for routes and initial routes.
  static const String id = "chat_screen";

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String messageText;

  final messageController = TextEditingController();

  // Get current user.
  void getUser() async {
    try {
      if (_auth != null) {
        loggedInUser = _auth.currentUser!;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('WeChat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageController.clear();
                      await _firestore.collection("messages").add({
                        "text": messageText,
                        "sender": loggedInUser.email,
                        // "time": FieldValue.serverTimestamp(),
                      }).whenComplete(() => print("completed"));
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("messages").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final messages = snapshot.data!.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            var data = message.data() as Map;
            final String messageText = data["text"].toString();
            final String messageSender = data["sender"].toString();
            // final Timestamp messageTime = message.data()["time"] as Timestamp;

            final currentUser = loggedInUser.email;

            final messageBubble = MessageBubble(
              messageText: messageText,
              messageSender: messageSender,
              isMe: currentUser == messageSender,
              // time: messageTime,
            );
            messageBubbles.add(messageBubble);
            // messageBubbles
            // .sort((a, b) => b.time.toString().compareTo(a.time.toString()));
          }

          return Expanded(
              child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: messageBubbles,
          ));
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.messageText,
      required this.messageSender,
      required this.isMe});

  final String messageText;
  final String messageSender;
  final bool isMe;
  // final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            messageSender,
            style: TextStyle(fontSize: 10.0),
          ),
          Material(
            shadowColor: Colors.black,
            elevation: 15.0,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30.0 : 0.0),
              bottomLeft: Radius.circular(30.0),
              topRight: Radius.circular(isMe ? 0.0 : 30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: isMe ? Colors.grey : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                messageText,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black, fontSize: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
