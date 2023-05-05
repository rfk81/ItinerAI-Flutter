import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  
  List<ChatModel> chatList = [];
  
  List<ChatModel> get getChatList {
    return chatList;
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required $model}) async {

// Delete the previous messages
      chatList.clear();

      List<ChatModel> response = await ApiService.sendMessageGPT(
        message: msg,
        modelId: $model,
      );
    chatList.add(response.last); 
    notifyListeners();
  }
}


