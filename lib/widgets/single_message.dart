import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime dateTime;
  const SingleMessage({Key? key,
    required this.message,
    required this.isMe,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF3C7754) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 12 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 12),
                  ),
                  border: Border.all(
                      width: 1,
                      color: isMe
                          ? const Color(0xFF3C7754)
                          : const Color.fromARGB(255, 241, 241, 241))),
              child: Text(
                message,
                style: TextStyle(
                    color:
                        isMe ? Colors.white : const Color.fromARGB(255, 75, 75, 75)),
              ),
            )
          ],
        ),
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(DateFormat("dd MMMM, HH:mm").format(dateTime),
                style: const TextStyle(color: Colors.grey)),
          ),
        )
      ],
    );
  }
}
