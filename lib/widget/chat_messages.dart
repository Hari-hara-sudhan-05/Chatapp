import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:chatapp/widget/message_box.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }
          if (chatSnapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final loadedMessages = chatSnapshot.data!.docs;

          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final currentMessage = loadedMessages[index].data();
                final nextMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1]
                    : null;
                final currentMessagesUid = currentMessage['userId'];
                final nextMessageUid =
                    nextMessage != null ? nextMessage['userId'] : null;
                final UserIsSame = currentMessagesUid == nextMessageUid;
                if (UserIsSame) {
                  return MessageBox.next(
                      message: currentMessage['text'],
                      isMe: currentMessagesUid == user!.uid);
                } else {
                  return MessageBox.first(
                      username: currentMessage['username'],
                      image: currentMessage['userImage'],
                      message: currentMessage['text'],
                      isMe: currentMessagesUid == user!.uid);
                }
              });
        });
  }
}
