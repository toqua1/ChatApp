
import 'package:chatapp/constants/constants.dart';
import 'package:chatapp/hive/chat_history.dart';
import 'package:chatapp/hive/gemini_user_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  //get chat history box
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox) ;
//get user box
  static Box<GeminiUserModel> getGeminiUser() =>
      Hive.box<GeminiUserModel>(Constants.userBox) ;
}