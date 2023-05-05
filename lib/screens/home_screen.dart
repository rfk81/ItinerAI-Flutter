import 'package:flutter/material.dart';
import 'package:itinerai/providers/chats_provider.dart';
import 'package:provider/provider.dart';
import '../services/assets_manager.dart';
import 'chat_screen.dart';
import 'package:itinerai/constants/api_consts.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _countryListController = TextEditingController();
  String _selectedDays = '1';
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final chatProvider = Provider.of<ChatProvider>(context);
    
    return MaterialApp(
      title: 'Home Screen',
      debugShowCheckedModeBanner: false,
      home: Scaffold
      (
        appBar: AppBar
            (
              title: const Text('ItinerAI: Organiza tus viajes con IA'),
            ),
        body: Column
        (
          children: 
          [
            Image.asset(
              AssetsManager.openaiLogo,
              height: 150,
              width: 150,
              fit: BoxFit.fitWidth,
            ),
            Container
                (
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 50, bottom: 50),
                
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text.rich(
                              TextSpan(
                                text: 'Destino/s:\n',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '(Separados por coma)',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          //  const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: _countryListController,
                                decoration: const InputDecoration(
                                //  hintText: ' Introduce destino',
                                  
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            Padding
                (
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Nº días:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                            ),
                            const Spacer(),
                            DropdownButton<String>(
                              value: _selectedDays,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDays = newValue!;
                                });
                              },
                              items: List.generate(
                                10,
                                (index) => DropdownMenuItem(
                                  value: (index + 1).toString(),
                                  child: Text('${index + 1}'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            Expanded
            (
              child: Padding
              (
                padding: const EdgeInsets.all(10.0),
                child: Column
                (
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
         
            Container
            (
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
                  
                  child: ElevatedButton
                  (
                      onPressed: () async {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatScreen()),
                      );
                      await sendMessageFCT(
                        $model: model,
                        chatProvider: chatProvider);
                    },
                      child: const Text('Enviar datos'),
                  ),
            ),
          ],
        ),
      ),
    );
  }

Future<void> sendMessageFCT(
      {required String $model,
      required ChatProvider chatProvider}) async {
   
    
    try {
      String prompt = 'Muestra una ruta turistica con una serie de actividades que pueda hacer en cada destino a partir del/los destino/s que te proporcionaré y la cantidad de días para el viaje. Destinos: $_countryListController.text y $_selectedDays de días';

      setState(() {
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: prompt, $model: model);

      setState(() {});
    } catch (error) {
      print(error.toString());
        
      
    } finally {
      setState(() {
      });
    }
  }
}