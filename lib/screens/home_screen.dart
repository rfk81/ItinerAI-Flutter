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
  final TextEditingController suggestController_ = TextEditingController();
  String _selectedDays = '1';
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  String itinerarioSugerido='';


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
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 50, bottom: 30),
                
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
                    mainAxisAlignment: MainAxisAlignment.end,

                    children:
                    [
                      const Text(
                        'Sugerencias para el viaje:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),

                      Expanded(child: TextFormField(
                        maxLines: 3,
                        controller: suggestController_,
                        decoration: const InputDecoration(
                          hintText: 'Escribe tus sugerencias',
                          border: OutlineInputBorder(),
                        ),
                      ))
                    ]
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
                        MaterialPageRoute(builder: (context) => const ChatScreen(

                        )),
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
      String prompt = 'Muestra una ruta turistica con una serie de actividades que pueda hacer en cada destino a partir del/los destino/s que te proporcionaré y la cantidad de días para el viaje. Destinos: $_countryListController.text y $_selectedDays de días. También sigue las siguientes sugerencias: $suggestController_'
      +'Respecto al itinerario, rellena la siguiente estructura, dentro de las comillas( pero sin mostrar las comillas)'+
      'siguiendo estrictamente las siguientes instrucciones'+
      '1. Añade unos gastos estimados hipotéticos correspondientes al total de los días en concepto de cada variable que se muestra en la estructra'+
      ' Añade los datos en cantidad numérica con el símbolo del €, 2. Hazlo sin alterar la estructura predefinida o los nombres de las variables'+
      '3. Añade esta estructura 1 sola vez al final del itinerairio completo,'+
      '4. La estructura es la siguiente: ' +
              'Vuelos: ""\n' +
              'Alojamiento: ""\n' +
              'Transporte: ""\n' +
              'Comida: ""\n' +
              'Entradas: ""';

      setState(() {
        textEditingController.clear();
        focusNode.unfocus();
        
      });
      String itinerario1 = await chatProvider.sendMessageAndGetAnswers(
          msg: prompt, $model: model);

      setState(() {
        itinerarioSugerido = itinerario1;
      });
    } catch (error) {
      print(error.toString());
        
      
    } 

    
    
    finally {
      setState(() {
      });
    }
  }


}