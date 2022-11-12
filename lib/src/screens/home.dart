
import 'package:flutter/material.dart';
import 'package:luva/bluetooth.dart';
import 'package:luva/src/screens/expression_list.dart';
import 'package:luva/src/screens/language_list_dialog.dart';
import 'package:luva/src/screens/translation_screen.dart';
import '../models/sensor_data.dart';
import '../repositories/language_repository.dart' as language_repository;

import '../models/language.dart';
import 'sensor_data_notifier.dart';

class Home extends StatefulWidget 
{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> 
{

  Language _currentSelectedLanguage = Language(name: "Libras");
  Future<List<Language>> _languages = Future.delayed(Duration(seconds: 5), () => linguagens);


  String _infoText = "Conectando";
  String _buttonText = "Conectar";
  bool _enableScreen = false;
  bool _enableButton = false;



  void setCurrentScreenState(BluetoothConnectionState currentBluetoothState)
  {
    switch(currentBluetoothState)
    {
      case BluetoothConnectionState.bluetoothDisabled:
        _infoText = "Bluetooth Desabilitado";
        _buttonText = "Conectar";
        _enableScreen = false;
        _enableButton = true;
        break;
      
      case BluetoothConnectionState.permissionDenied:
        _infoText = "Permissão Negada";
        _buttonText = "Conectar";
        _enableScreen = false;
        _enableButton = true;
        break;

      case BluetoothConnectionState.connecting:
        _infoText = "Conectando...";
        _buttonText = "Conectar";
        _enableScreen = false;
        _enableButton = false;
        break;

      case BluetoothConnectionState.deviceNotFound:
        _infoText = "Dispositivo Não Encontrado";
        _buttonText = "Conectar";
        _enableScreen = false;
        _enableButton = true;
        break;

      case BluetoothConnectionState.mtuDenied:
        _infoText = "Não foi possível conectar";
        _buttonText = "Conectar";
        _enableScreen = false;
        _enableButton = true;
        break;

      case BluetoothConnectionState.deviceConnected:
        _infoText = "Conectado";
        _buttonText = "Desconectar";
        _enableScreen = true;
        _enableButton = true;
        break;

      case BluetoothConnectionState.deviceDisconnected:
        _infoText = "Desconectado";
        _buttonText = "Reconectar";
        _enableScreen = false;
        _enableButton = true;
        break;

      case BluetoothConnectionState.none:
        _infoText = "Conectando...";
        _buttonText = "Conectar";
        _enableScreen = false;
        _enableButton = false;
        break;
    }
  }





  Future<void> addLanguage(String languageName) async
  {
    print("Adicionando linguagem");
    
    Language language = Language(name: languageName, deviceId: SensorDataNotifier.of(context).device.id);
    await language_repository.insertLanguage(language);
    //Future.delayed(Duration(milliseconds: 500), () => print("Linaguagem adicionada => $languageName"));
  }

  Future<void> deleteLanguage(Language language) async
  {
    //print("deletando linguagem ${language.name}");
    /*
    Future.delayed(Duration(milliseconds: 500), ()
    {
      linguagens.remove(language);
    });
    */
    print("deletando linguagem ${language.name}");
    await language_repository.deleteLanguage(language.id!);
    setState(() => SensorDataNotifier.of(context).currentLanguage = null);
  }


  Future<void> editLanguage(Language language, String languageName) async
  {
    print("editando linguagem");
    
    Language updatedLanguage = Language(
      id: language.id,
      name: languageName,
      deviceId: language.deviceId
    );
    await language_repository.updateLanguage(updatedLanguage);

    setState(() => SensorDataNotifier.of(context).currentLanguage = null);

    //Future.delayed(Duration(milliseconds: 500), () => print("Linaguagem editada => $languageName"));
  }


  void onSelectLanguage(Language language)
  {
    print("selected language => ${language.name}");
    SensorDataNotifier.of(context).currentLanguage = language;
  }


  @override
  Widget build(BuildContext context) 
  {
    final SensorData data = SensorDataNotifier.of(context);
    print("Device => ${SensorDataNotifier.of(context).device.name}");

    setCurrentScreenState(data.currentBluetoothConnectionState);

    final Widget bottomButton = ElevatedButton(
      onPressed: (!_enableButton)? null :
      () 
      {
        (_buttonText == "Desconectar")? data.disconnectBluetooth() : data.reconnectBluetooth();
      },
      child: Text(_buttonText)
    );

    return Scaffold(
      
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_infoText),
            bottomButton
          ],
        )
      ),
      appBar: AppBar(
        title: const Text("Tradução"),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list),
            tooltip: "Linguagens",
            onPressed: ()
            {
              showLanguageListDialog(
                context: context,
                addLanguage: addLanguage,
                deleteLanguage: deleteLanguage,
                editLanguage: editLanguage,
                onSelectLanguage: onSelectLanguage
              );
            }
          )
        ],
      ),
      body: AbsorbPointer(
        absorbing: false,//!_enableScreen,
        child: Container(
          color: (_enableScreen)? null : Colors.black12,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.translate),
                      text: "Tradução"
                    ),
                    Tab(
                      icon: Icon(Icons.sign_language),
                      text: "Expressões"
                    )
                  ]
                ),
                Flexible(
                  child: TabBarView(
                    children: [
                      TranslationScreen(),
                      ExpressionList()
                    ],
                  ),
                )
              ]
            )
          ),
        ),
      )
    );
  }
}


List<Language> linguagens = [
  Language(name: "Libras"),
  Language(name: "Libras 1"),
  Language(name: "Libras 2"),
  Language(name: "Libras 3"),
  Language(name: "Libras 4"),
  Language(name: "Libras 5"),
  Language(name: "Libras 6"),
  Language(name: "Libras 7"),
];