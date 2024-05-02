import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox.first(
      {required this.username,
      super.key,
      required this.image,
      required this.message,
      required this.isMe})
      : isFirstMessage = true;

  const MessageBox.next({super.key, required this.message, required this.isMe})
      : isFirstMessage = false,
        username = null,
        image = null;

  final bool isFirstMessage;
  final String? username;
  final String? image;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (image != null)
          Positioned(
            top: 15,
            right: isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(image!),
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstMessage) const SizedBox(height: 20),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                        color: isMe
                            ? Colors.grey[300]
                            : theme.colorScheme.secondary.withAlpha(200),
                        borderRadius: BorderRadius.only(
                          topLeft: !isMe && isFirstMessage
                              ? Radius.zero
                              : const Radius.circular(12),
                          topRight: isMe && isFirstMessage
                              ? Radius.zero
                              : const Radius.circular(12),
                          bottomLeft:const  Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        )),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Text(
                      message,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe
                            ? Colors.black87
                            : theme.colorScheme.onSecondary,
                      ),
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
