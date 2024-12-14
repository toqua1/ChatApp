import 'package:chatapp/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import '../../../models/gemini_message_model.dart';

class GeminiChatRoom extends StatefulWidget {
  const GeminiChatRoom({super.key});

  @override
  State<GeminiChatRoom> createState() => _GeminiChatRoomState();
}

class _GeminiChatRoomState extends State<GeminiChatRoom> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final List<GeminiMessage> _messages = [];
  bool _isLoading = false;

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 1,
        leading:   Image.asset('assetsEdited/robot1.png'),
        title: Text('Gemini Gpt', style: Theme.of(context).textTheme.titleLarge,),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index){
                  final message = _messages[index];
                  return ListTile(
                    title: Align(
                      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: message.isUser ?
                              Theme.of(context).colorScheme.primary :
                              Theme.of(context).colorScheme.secondary,
                              borderRadius: message.isUser ?
                              const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)
                              ) :
                              const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              )
                          ),
                          child: Text(
                              message.text,
                              style: message.isUser ? Theme.of(context)
                                  .textTheme.bodyLarge?.copyWith(color: Colors
                                  .black) :
                              Theme.of(context).textTheme.bodyMedium?.copyWith
                                (color: Colors.black)
                          )
                      ),
                    ),
                  );
                }
            ),
          ),

          // user input
          Padding(
            padding: const EdgeInsets.only(bottom: 32,top: 16.0, left: 16.0, right: 16),
            child: Container(
              decoration: BoxDecoration(
                  color:Provider.of<ProviderApp>(context).themeMode
                      ==ThemeMode.dark
                      ?Colors.black54
                      :Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3)
                    )
                  ]
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.grey
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20)
                      ),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  _isLoading ?
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ) :
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => callGeminiModel(_controller.text),
                      child: Icon(Icons.send_rounded,
                      color: Theme.of(context).colorScheme.primary,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  callGeminiModel(String msg)async{
    try{
      if(_controller.text.isNotEmpty){
        _messages.add(GeminiMessage(text: msg, isUser: true));
        setState(() {
          _isLoading = true;
          _controller.clear();
        });
      }
      final model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: dotenv.env['GOOGLE_API_KEY']!);
      final prompt = msg.trim();/*remove leading & trailing
      spaces*/
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(GeminiMessage(text: response.text!, isUser: false));
        _isLoading = false;
        _scrollDown();
      });

    }catch(e){
      print("Error : $e");
    }
  }
}
