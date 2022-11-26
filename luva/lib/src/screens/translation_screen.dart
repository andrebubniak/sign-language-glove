import 'package:flutter/material.dart';
import 'package:luva/src/utils/sensor_data_notifier.dart';

class TranslationScreen extends StatefulWidget
{
  const TranslationScreen({super.key});

  @override
  State createState() => TranslationScreenState();
}

class TranslationScreenState extends State<TranslationScreen>
{

  bool _keepTranslatedText = false;

  String textToDisplay = '';


  @override
  Widget build(BuildContext context)
  {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                width: double.maxFinite,
                height: screenHeight/8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    strokeAlign: StrokeAlign.center,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12))
                ),
                child: SingleChildScrollView(
                  child: StreamBuilder<String>(
                    initialData: '',
                    stream: SensorDataNotifier.of(context).translationStream,
                    builder: (context, snapshot)
                    {
                      if(snapshot.hasData)
                      {
                        if(snapshot.data! == "relaxado")
                        {
                          return Container();
                        }
    
                        textToDisplay = (_keepTranslatedText)? "$textToDisplay ${snapshot.data!}" : snapshot.data!;
                        return Text(
                          textToDisplay,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                      return Container();
                    },
                  ),
                )
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _keepTranslatedText,
                    onChanged: (value)
                    {
                      setState(() {_keepTranslatedText = value!;});
                    }
                  ),
                  const Text(
                    "Manter Histórico",
                    style: TextStyle(
                      fontSize: 16
                    )
                  ),
                ],
              ),
              !_keepTranslatedText? Container() : Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () 
                  {
                    setState(() {textToDisplay = '';});
                  },
                  child: const Text("Apagar")
                ),
              ),
              //SizedBox(width: 8)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Text(
                  (SensorDataNotifier.of(context).currentLanguage == null)? "Nenhuma Linguagem Selecionada" :
                  "Linguagem Atual: ${SensorDataNotifier.of(context).currentLanguage!.name}"
                ),
                Text(
                  (SensorDataNotifier.of(context).currentLanguage != null && SensorDataNotifier.of(context).currentModel == null)? "Modelo Não Treinado" : ""
                )
              ],
            )
          )
        ],
      ),
    );
  }
  
}