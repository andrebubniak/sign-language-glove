

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luva/src/screens/sensor_data_notifier.dart';

class TranslationScreen extends StatefulWidget
{
  TranslationScreen({super.key});
  final TesteStream teste = TesteStream();

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
    //final teste = TesteStream2(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: double.maxFinite,
              height: screenHeight/8,
              //constraints: BoxConstraints(maxHeight: screenHeight/10),
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
                  stream: widget.teste.stream,
                  builder: (context, snapshot)
                  {
                    if(snapshot.hasData)
                    {
                      textToDisplay = (_keepTranslatedText)? textToDisplay + ' ' + snapshot.data! : snapshot.data!;
                      return Text(
                        textToDisplay,
                        style: TextStyle(
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
                Text(
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
                child: Text("Apagar")
              ),
            ),
            //SizedBox(width: 8)
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            (SensorDataNotifier.of(context).currentLanguage == null)? "Nenhuma Linguagem Selecionada" :
            "Linguagem Atual: ${SensorDataNotifier.of(context).currentLanguage!.name}"
          )
        )
      ],
    );
  }
  
}





class TesteStream2
{
  late final StreamController<String> _streamController;
  Stream<String> get stream => _streamController.stream;

  String _streamString = 'B';

  TesteStream2(BuildContext context)
  {
    _streamController = StreamController<String>.broadcast();
    Timer.periodic(Duration(seconds: 1), (timer)
    {
      if(SensorDataNotifier.of(context).flex1 > 800)
      {
        _streamString = 'A';
      }
      else _streamString = 'B';
      //_streamString = (_streamString == 'B')? 'A' : 'B';
      _streamController.sink.add(_streamString);
    });
  }

}






class TesteStream
{
  late final StreamController<String> _streamController;
  Stream<String> get stream => _streamController.stream;

  String _streamString = 'B';

  TesteStream()
  {
    _streamController = StreamController<String>.broadcast();
    Timer.periodic(Duration(seconds: 1), (timer)
    {
      _streamString = (_streamString == 'B')? 'A' : 'B';
      _streamController.sink.add(_streamString);
    });
  }

}