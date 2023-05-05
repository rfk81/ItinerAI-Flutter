import 'package:itinerai/providers/chats_provider.dart';
import 'package:itinerai/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({super.key});
  
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final chatProvider = Provider.of<ChatProvider>(context);
    
    return Scaffold(
      appBar: AppBar
      (
        elevation: 2,
        title: const Text("ItinerAI: tu app de viajes"),
      ),

      body: SafeArea
      (
        child: Column
        (
          children:
          [
            Flexible
            (
              child: ListView.builder
                  (
                  itemCount: chatProvider.getChatList.length,
                  itemBuilder: (context, index) 
                  {
                    return ChatWidget
                    (
                    msg: chatProvider.getChatList[index].msg, 
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                    );
                  }
                  ),
            ),
            const SizedBox(height: 15,),
          ], 
        ),
      ),
    );
  }
}
