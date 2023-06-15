import 'package:flutter/material.dart';
import 'package:itinerai/providers/chats_provider.dart';
import 'package:itinerai/screens/grafica_screen.dart';
import 'package:itinerai/widgets/chat_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  bool showButton = false;

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

    if (chatProvider.getChatList.isNotEmpty) {
      showButton = chatProvider.getChatList.last == chatProvider.getChatList.last;
    } else {
      showButton = false;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("ItinerAI: tu app de viajes"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  final chat = chatProvider.getChatList[index];
                  return ChatWidget(
                    msg: chat.msg,
                    chatIndex: chat.chatIndex,
                  );
                },
              ),
            ),
            if (showButton)
              ElevatedButton(
                onPressed: () {
                  final lastChatMessage = chatProvider.getChatList.last.msg;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GraficaScreen(mensaje: lastChatMessage)),
                  );
                },
                child: const Text('Ver presupuesto'),
              ),
          ],
        ),
      ),
    );
  }
}
