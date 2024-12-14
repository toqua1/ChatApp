import 'package:chatapp/screens/Gemini%20Chat/screens/gemini_chat_room.dart';
import 'package:flutter/material.dart';

class GeminiChatCard extends StatelessWidget {
  const GeminiChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GeminiChatRoom()));
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0),
        child: Card(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assetsEdited/robot2.png')),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Gemini Gpt',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "serif",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
