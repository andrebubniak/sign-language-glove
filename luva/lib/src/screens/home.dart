
import 'package:console_flutter/screens/console_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:luva/src/utils/bluetooth.dart';
import 'package:luva/src/screens/expression_list.dart';
import 'package:luva/src/utils/dialogs/language_list_dialog.dart';
import 'package:luva/src/screens/translation_screen.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import '../utils/sensor_data.dart';

import '../models/language.dart';
import '../utils/sensor_data_notifier.dart';

import 'package:console_flutter/console_flutter.dart' as flutter_console;

class Home extends StatefulWidget 
{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> 
{

  String _infoText = "Conectando";
  String _buttonText = "Conectar";
  bool _enableScreen = false;
  bool _enableButton = false;


  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  void deactivate()
  {
    SensorDataNotifier.of(context).disconnectBluetooth();
    super.deactivate();
  }

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

      case BluetoothConnectionState.timeoutOnConnection:
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

  // #region language related functions

  Future<void> addLanguage(String languageName) async
  {    
    Language language = Language(name: languageName, deviceId: SensorDataNotifier.of(context).device.id);
    await Language.insert(language);
    flutter_console.log("Inserted Language => ${language.name}");
  }

  Future<void> deleteLanguage(Language language) async
  {
    flutter_console.log("Deleted Language => ${language.name}");
    await Language.delete(language.id!);
    setState(() => SensorDataNotifier.of(context).currentLanguage = null);
  }


  Future<void> editLanguage(Language language, String languageName) async
  {
    Language updatedLanguage = Language(
      id: language.id,
      name: languageName,
      deviceId: language.deviceId
    );

    await Language.update(updatedLanguage);
    flutter_console.log("Updating Language: ${language.name} => ${updatedLanguage.name}");
    setState(() => SensorDataNotifier.of(context).currentLanguage = null);
  }


  void onSelectLanguage(Language language)
  {
    flutter_console.log("Language Selected => ${language.name}");
    SensorDataNotifier.of(context).currentLanguage = language;
  }


  // #endregion


  // debug options menu (console, db viewer)
  Widget get debugOptions => PopupMenuButton(
    itemBuilder: (context)
    {
      return const [
        PopupMenuItem<int>(
          value: 0,
          child: Text("Console")
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text("Banco de Dados")
        )
      ];
    },
    onSelected: (value)
    {
      switch(value)
      {
        case 0:
          flutter_console.log("Opening Console");
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConsoleScreen()));
          break;

        case 1:
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DatabaseList()));
          break;

        default: break;
      }
    },
  );





  @override
  Widget build(BuildContext context) 
  {
    final SensorData data = SensorDataNotifier.of(context);
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
        padding: const EdgeInsets.all(12),
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
          (kDebugMode)? debugOptions : Container(),
          IconButton(
            icon: const Icon(Icons.view_list),
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
        absorbing: !_enableScreen,
        child: Container(
          color: (_enableScreen)? null : Colors.black12,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: const [
                TabBar(
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
